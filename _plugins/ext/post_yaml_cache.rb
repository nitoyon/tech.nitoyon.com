# Convertible#read_yaml cache
#
# This plugin caches `Convertible#read_yaml` result on _caches/posts.yml.

module Jekyll
  class Site
    attr_accessor :yaml_cache
    alias :post_yaml_cache_original_read :read

    def read
      @yaml_cache = YamlCache.new(self)
      post_yaml_cache_original_read()
    end
  end

  class YamlCacheGenerator < Generator
    def generate(site)
      site.yaml_cache.save
    end
  end

  class Page
    alias :post_yaml_cache_original_render :render

    def render(layouts, site_payload)
      return if site.is_modified_only && !self.modified

      puts "rendering " + self.destination('/')
      post_yaml_cache_original_render(layouts, site_payload)
      self.rendered = true
    end
  end

  class Post
    alias :post_yaml_cache_original_render :render

    def render(layouts, site_payload)
      return if site.is_modified_only && !self.modified

      puts "rendering " + self.destination('/')
      post_yaml_cache_original_render(layouts, site_payload)
      self.rendered = true
    end
  end

  module Convertible
    attr_accessor :modified
    attr_accessor :rendered

    alias :post_yaml_cache_original_write :write

    # Read the YAML frontmatter.
    #
    # base - The String path to the dir containing the file.
    # name - The String filename of the file.
    # opts - optional parameter to File.read, default at site configs
    #
    # Returns nothing.
    def read_yaml(base, name, opts = {})
      ret = site.yaml_cache.get(base, name, self.merged_file_read_opts(opts))
      self.content = ret[:content]
      self.data = ret[:yaml]
      self.modified = ret[:modified]
    end

    def write(dest)
      return unless self.rendered

      puts "writing " + self.destination('/')
      post_yaml_cache_original_write(dest)
    end
  end

  # cache yaml format
  # { key => { 'modified' => Time,    # file modified time
  #            'yaml'     => { },     # yaml cache
  #            'content'  => "...",   # content cache
  #          },
  # }
  #
  # After Site#read was called, YamlCache#modified represents whether cache
  # is modified and YamlCache#yaml_modified represents whether YAML is modified.
  class YamlCache
    attr_accessor :modified, :yaml_modified

    def initialize(site)
      @site = site
      @cache_path = File.join(@site.source, '_caches/posts.yml')
      @cache = nil
      @yaml_modified = @modified = false
    end

    def ret_hash(yaml, content, yaml_modified, content_modified, updated)
      { :modified         => updated || yaml_modified || content_modified,
        :yaml_modified    => yaml_modified,
        :content_modified => content_modified,
        :yaml             => Marshal.load(Marshal.dump(yaml)) || {},
        :content          => content,
      }
    end
  
    # Get cache or create cache
    #
    # Returns the Hash representation of the cache data.
    def get(base, name, opts)
      self.load if @cache.nil?
      path = Jekyll.sanitized_path(base, name)
      key = path[@site.source.length..-1]
      mtime = File.mtime(path)

      if @cache.has_key?(key) && mtime == @cache[key]['modified']
        # file is not modified
        ret_hash(@cache[key]['yaml'], @cache[key]['content'], false, false, false)
      else
        puts "parsed yaml #{key}..."
        self.set_content(key, path, mtime, opts)
      end
    end

    def set_content(key, path, mtime, opts)
      # get current data
      begin
        content = File.read(path, opts)
        if content =~ /\A(---\s*\n.*?\n?)^((---|\.\.\.)\s*$\n?)/m
          content = $POSTMATCH
          yaml = SafeYAML.load($1)
        end
      rescue SyntaxError => e
        Jekyll.logger.warn "YAML Exception reading #{path}: #{e.message}"
      rescue Exception => e
        Jekyll.logger.warn "Error reading file #{path}: #{e.message}"
      end
      yaml ||= {}

      # get cache
      if @cache.has_key?(key)
        old_yaml = @cache[key]['yaml']
        old_content = @cache[key]['content']
      end

      # check updated
      yaml_modified = YAML.dump(old_yaml) != YAML.dump(yaml)
      content_modified = old_content != content
      modified = yaml_modified || content_modified
      @yaml_modified |= yaml_modified
      @modified = true

      # set cache
      @cache[key] = {
        'content' => content,
        'yaml' => yaml,
        'modified' => mtime,
      }
      puts "modify cache: yaml=#{yaml_modified}, content=#{content_modified}, mtime=#{mtime}"

      ret_hash(yaml, content, yaml_modified, content_modified, true)
    end

    def load
      @cache = {}
      if FileTest.file?(@cache_path)
        begin
          @cache = YAML.load_file(@cache_path)
          @cache = {} unless @cache
        rescue => e
          puts "YAML Exception reading #{yaml_path}: #{e.message}"
        end
      end
    end

    def save
      if @modified
        yaml = YAML.dump(@cache)
        File.open(@cache_path, "w") { |f| f.write(yaml) }
      end
    end

    def clear_modified
      @modified = @yaml_modified = false
    end
  end
end
