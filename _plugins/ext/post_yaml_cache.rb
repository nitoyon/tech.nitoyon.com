# Convertible#read_yaml cache
#
# This plugin caches `Convertible#read_yaml` result on _caches/posts.yml.

module Jekyll
  class Site
    attr_accessor :yaml_cache

    def read
      @yaml_cache = YamlCache.new(self) if @yaml_cache.nil?

      self.read_layouts
      self.read_directories

      @yaml_cache.save
    end
  end

  module Convertible
    # Read the YAML frontmatter.
    #
    # base - The String path to the dir containing the file.
    # name - The String filename of the file.
    #
    # Returns nothing.
    def read_yaml(base, name)
      source = File.join(base, name)

      begin
        ret = site.yaml_cache.get(source)

        self.content = ret[:content]
        self.data = ret[:yaml]
        self.modified = ret[:modified]
        self.yaml_modified = ret[:yaml_modified]
      rescue => e
        puts "YAML Exception reading #{name}: #{e.message}"
        raise e
      end

      self.data ||= {}
    end
  end

  # cache yaml format
  # { key => { 'modified' => Time,    # file modified time
  #            'yaml'     => { },     # yaml cache
  #            'content'  => "...",   # content cache
  #          },
  # }
  class YamlCache
    def initialize(site)
      @site = site
      @cache_path = File.join(@site.source, '_caches/posts.yml')
      @cache = nil
      @file_modified = false
    end

    def ret_hash(yaml, content, yaml_modified, content_modified, updated)
      { :modified         => updated || yaml_modified || content_modified,
        :yaml_modified    => yaml_modified,
        :content_modified => content_modified,
        :yaml             => Marshal.load(Marshal.dump(yaml)),
        :content          => content,
      }
    end
  
    # Get cache or create cache
    #
    # Returns the Hash representation of the cache data.
    def get(path)
      self.load if @cache.nil?
      key = path[@site.source.length..-1]
      mtime = File.mtime(path)

      if @cache.has_key?(key) && mtime == @cache[key]['modified']
        # file is not modified
        ret_hash(@cache[key]['yaml'], @cache[key]['content'], false, false, false)
      else
        puts "parsed yaml #{key}..."
        self.set_content(key, path, mtime)
      end
    end

    def set_content(key, path, mtime)
      # get current data
      content = File.read(path)
      if content =~ /^(---\s*\n.*?\n?)^(---\s*$\n?)/m
        content = $POSTMATCH
        yaml = YAML.load($1)
      end

      # get cache
      if @cache.has_key?(key)
        old_yaml = @cache[key]['yaml']
        old_content = @cache[key]['content']
      end

      # check updated
      yaml_modified = YAML.dump(old_yaml) != YAML.dump(yaml)
      content_modified = old_content != content
      modified = yaml_modified || content_modified
      @file_modified |= modified

      # set cache
      @cache[key] = {
        'content' => content,
        'yaml' => yaml,
        'modified' => mtime,
      }
      puts "modify cache: yaml=#{yaml_modified}, content=#{content_modified}" if modified

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
      if @file_modified
        yaml = YAML.dump(@cache)
        File.open(@cache_path, "w") { |f| f.write(yaml) }
      end
      @file_modified = @content_modified = false
    end
  end
end
