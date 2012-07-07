# This plugin modifies Site class and adds following functions.
#
#  - Reload modified plugin in --server and --auto mode.
#  - Skip unmodified post in --server and --auto mode.
#
# Dependent plugins:
#  - post_yaml_cache plugin
#  - archive plugin
#  - lang plugin

module Jekyll
  class Post
    attr_accessor :skipped

    alias :render_ext_orig :render unless self.instance_methods.include?(:render_ext_orig)
    def render(layouts, site_payload)
      src_mtime = File::mtime(File.join(@base, @name))
      dst_path = self.destination(@site.dest)
      dst_mtime = File::mtime(dst_path) if FileTest.exists?(dst_path)

      if dst_mtime && src_mtime <= dst_mtime && @site.is_modified_only
        self.skipped = true
      else
        puts "rendering #{self.name}"
        self.render_ext_orig(layouts, site_payload)
        self.skipped = false
        puts "rendered"
      end
    end
  end

  class Page
    attr_accessor :skipped

    alias :render_ext_orig :render unless self.instance_methods.include?(:render_ext_orig)
    def render(layouts, site_payload)
      src_path = File.join(@base, @dir, @name)
      src_mtime = File::mtime(File.join(@base, @dir, @name)) if FileTest.exists?(src_path)
      dst_path = self.destination(@site.dest)
      dst_mtime = File::mtime(dst_path) if FileTest.exists?(dst_path)

      if src_mtime && dst_mtime && src_mtime <= dst_mtime && @site.is_modified_only
        self.skipped = true
      else
        puts "rendering #{File.join(@dir, @name)}"
        self.render_ext_orig(layouts, site_payload)
        self.skipped = false
      end
    end
  end

  class Site
    def is_modified_only
      self.config['server'] && self.config['auto']
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
        dest_files << file unless file =~ /\/\.{1,2}$/ || file =~ /\/\.git$/
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

      require 'pp'
      puts 'obsolete files:'
      pp obsolete_files

      FileUtils.rm_rf(obsolete_files.to_a)
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