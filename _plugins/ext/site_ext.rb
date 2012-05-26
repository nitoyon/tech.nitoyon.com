# This plugin modifies Site class and adds following functions.
#  - Reload modified plugin in --server mode.
#  - Generate only modified post in --server mode.

module Jekyll
  class Post
    # base: path to `_post` dir
    # name: relative path from `base` dir
    attr_accessor :base, :name
    attr_accessor :skipped
  end

  class Site

    # Render the site to the destination.
    #
    # Returns nothing.
    #
    # Added logging and reloading plugins.
    def process
      puts "process: resetting"
      self.reset
      puts "process: reload_plugin"
      self.reload_plugin
      puts "process: reading"
      self.read
      puts "process: generating"
      self.generate
      puts "process: rendering"
      self.render
      puts "process: cleanuping"
      self.cleanup
      puts "process: writing"
      self.write
      puts "process: completed"
    end

    def reload_plugin
      unless self.safe
        Dir[File.join(self.plugins, "**/*.rb")].each do |f|
          load f
        end
      end
    end

    # Render the site to the destination.
    #
    # Returns nothing.
    #
    # Render only modified file.
    def render
      puts self.config['auto']
      self.posts.each do |post|
        src_mtime = File::mtime(File.join(post.base, post.name))
        dst_path = post.destination(self.dest)
        dst_mtime = File::mtime(post.destination(self.dest)) if FileTest.exists?(dst_path)
        if dst_mtime && src_mtime <= dst_mtime
          puts "skipping #{post.name}"
          post.skipped = true
        else
          puts "rendering #{post.name}"
          post.render(self.layouts, site_payload)
          post.skipped = false
          puts "rendered #{post.name}"
        end
      end

      self.pages.each do |page|
        page.render(self.layouts, site_payload)
      end

      self.categories.values.map { |ps| ps.sort! { |a, b| b <=> a } }
      self.tags.values.map { |ps| ps.sort! { |a, b| b <=> a } }
    rescue Errno::ENOENT => e
      # ignore missing layout dir
      puts e
    rescue Exception => e
      # log it
      puts e
      raise e
    end

    # Remove orphaned files and empty directories in destination.
    #
    # Returns nothing.
    def cleanup
      # all files and directories in destination, including hidden ones
      dest_files = Set.new
      Dir.glob(File.join(self.dest, "**", "*"), File::FNM_DOTMATCH) do |file|
        dest_files << file unless file =~ /\/\.{1,2}$/
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
        puts "writing #{post.name}"
      end
      self.pages.each do |page|
        page.write(self.dest)
      end
      self.static_files.each do |sf|
        sf.write(self.dest)
      end
    end
  end
end