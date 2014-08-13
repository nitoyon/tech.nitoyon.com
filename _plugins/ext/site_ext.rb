# This plugin modifies Site class and adds following functions.
#
#  - Skip unmodified post in not --server mode.
#
# Dependent plugins:
#  - post_yaml_cache plugin
#  - archive plugin
#  - lang plugin

module Jekyll
  class Site
    def is_modified_only
      self.future
    end

    # Public: Read, process, and write this Site to output.
    #
    # Returns nothing.
    def process
      t_total = Time.now
      t_reset = Time.now
      puts "process: resetting"
      self.reset
      t_reset = Time.now - t_reset

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
      puts "read:          #{t_read} sec"
      puts "generate:      #{t_generate} sec"
      puts "render:        #{t_render} sec"
      puts "cleanup:       #{t_cleanup} sec"
      puts "writing:       #{t_write} sec"
      puts "total:         #{t_total} sec"
    rescue Exception => e
      puts "Exception in process: #{e} #{e.backtrace.join("\n")}"
      raise e
    end
  end
end