#!/usr/bin/env ruby19
# referred https://gist.github.com/960150
# referred load_compass method at lib/sass/exec.rb

require 'sass'

module Jekyll
  module Converters
    class Scss
      def compass_sass_load_paths
        return [] unless jekyll_sass_configuration["compass"]
        require 'compass'
        Compass.configuration.sass_load_paths
      end

      def sass_dir_relative_to_site_source
        Jekyll.sanitized_path(@config["source"], sass_dir)
      end

      def sass_load_paths
        if safe?
          [sass_dir_relative_to_site_source]
        else
          (user_sass_load_paths + compass_sass_load_paths +
           [sass_dir_relative_to_site_source]).uniq
        end.select { |load_path|
          !load_path.is_a?(String) || File.directory?(load_path)
        }
      end
    end
  end
end