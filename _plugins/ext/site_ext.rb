# This plugin modifies Site class and adds following functions.
#
#  - Skip unmodified post in not --server mode.
#
# Dependent plugins:
#  - post_yaml_cache plugin
#  - archive plugin
#  - lang plugin

module Jekyll
  module Convertible
    def needs_render?
      self.modified
    end
  end

  class Post
    attr_accessor :skipped, :yaml_modified, :modified

    def needs_render?
      self.modified ||
        self.previous && self.previous.yaml_modified ||
        self.next && self.next.yaml_modified
    end

    def source
      File.join(@base, @name)[@site.source.length .. -1]
    end
  end

  class Page
    attr_accessor :skipped, :yaml_modified, :modified

    def needs_render?
      unless self.data.has_key?("update_policy")
        return self.modified
      end
      update_policy = self.data["update_policy"]

      @@template_cache ||= {}
      unless @@template_cache.has_key? update_policy
        @@template_cache[update_policy] = Liquid::Template.parse(update_policy)
      end
      template = @@template_cache[update_policy]

      update = template.render(
        { "page" => self }.deep_merge(self.site.site_payload), 
        { :filters => [Jekyll::Filters], :registers => { :site => self.site } })
      puts "#{self.destination('/')} updated: #{update.strip}" unless update.strip.empty?
      !update.strip.empty?
    end

    def source
      File.join(@base, @dir, @name)[@site.source.length .. -1]
    end
  end

  class Layout
    attr_accessor :yaml_modified, :modified
  end

  class Site
    def is_modified_only
      !self.future
    end

    # Render the site to the destination.
    #
    # Returns nothing.
    #
    # Added logging and reloading plugins.
    def process
      t_total = Time.now
      t_reset = Time.now
      puts "process: resetting"
      self.reset
      t_reset = Time.now - t_reset

      t_plugin = Time.now
      puts "process: reload_plugin"
      self.reload_plugin
      t_plugin = Time.now - t_plugin

      t_read = Time.now
      puts "process: reading"
      self.read
      t_read = Time.now - t_read

      t_generate = Time.now
      puts "process: generating"
      self.generate
      t_generate = Time.now - t_generate

      t_render = Time.now
      puts "process: rendering"
      self.render
      t_render = Time.now - t_render

      t_archive = Time.now
      puts "process: archives"
      self.generate_archives
      t_archive = Time.now - t_archive

      t_tag = Time.now
      puts "process: tags"
      self.generate_tags
      t_tag = Time.now - t_tag

      t_lang = Time.now
      puts "process: languages"
      self.generate_languages
      t_lang = Time.now - t_lang

      t_cleanup = Time.now
      puts "process: cleanuping"
      self.cleanup
      t_cleanup = Time.now - t_cleanup

      t_write = Time.now
      puts "process: writing"
      self.write
      t_write = Time.now - t_write

      t_total = Time.now - t_total

      puts "reset:         #{t_reset} sec"
      puts "reload_plugin: #{t_plugin} sec"
      puts "read:          #{t_read} sec"
      puts "generate:      #{t_generate} sec"
      puts "render:        #{t_render} sec"
      puts "archive:       #{t_archive} sec"
      puts "tag:           #{t_tag} sec"
      puts "languages:     #{t_lang} sec"
      puts "cleanup:       #{t_cleanup} sec"
      puts "writing:       #{t_write} sec"
      puts "total:         #{t_total} sec"
    rescue Exception => e
      puts "Exception in process: #{e} #{e.backtrace.join("\n")}"
      raise e
    end

    def reload_plugin
      if self.config['server'] && self.config['auto']
        Dir[File.join(self.plugins, "**/*.rb")].each do |f|
          load f
        end
      end
    end

    # Remove orphaned files and empty directories in destination.
    #
    # Returns nothing.
    def cleanup
      # all files and directories in destination, including hidden ones
      dest_files = Set.new
      Dir.glob(File.join(self.dest, "**", "*"), File::FNM_DOTMATCH) do |file|
        dest_files << file unless file =~ /\/\.{1,2}$/ || file =~ /\/\.git/
      end

      # files to be written
      files = Set.new
      self.posts.each do |post|
        files << post.destination(self.dest)
      end
      self.pages.each do |page|
        files << page.destination(self.dest)
      end
      self.static_files.each do |sf|
        files << sf.destination(self.dest)
      end

      # adding files' parent directories
      dirs = Set.new
      dirs << self.dest
      files.each { |file|
        dir = File.dirname(file)
        until dirs.include?(dir) or dir == File.dirname(dir)
          dirs << dir
          dir = File.dirname(dir)
        end
      }
      files.merge(dirs)

      obsolete_files = dest_files - files

      FileUtils.rm_rf(obsolete_files.to_a)
    end

    # Render the site to the destination.
    #
    # Returns nothing.
    def render
      payload = site_payload
      self.posts.each do |post|
        self.render_if_modified(post, payload)
      end

      self.pages.each do |page|
        self.render_if_modified(page, payload)
      end

      self.categories.values.map { |ps| ps.sort! { |a, b| b <=> a } }
      self.tags.values.map { |ps| ps.sort! { |a, b| b <=> a } }
    rescue Errno::ENOENT => e
      # ignore missing layout dir
    end

    def render_if_modified(page, payload)
      page.skipped = self.is_modified_only && !page.needs_render?
      unless page.skipped
        page.render(self.layouts, payload)
        puts "rendered " + page.destination('/')
      end
    end

    # Write static files, pages, and posts.
    #
    # Write only modified file.
    #
    # Returns nothing.
    def write
      self.posts.each do |post|
        next if post.skipped
        post.write(self.dest)
        puts "writing " + post.destination('/')
      end
      self.pages.each do |page|
        next if page.skipped
        page.write(self.dest)
        puts "writing " + page.destination('/')
      end
      self.static_files.each do |sf|
        sf.write(self.dest)
      end
    end
  end
end