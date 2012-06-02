#!/usr/bin/env ruby19
# referred https://gist.github.com/960150
# referred load_compass method at lib/sass/exec.rb

require 'sass'

module Jekyll
  class SassConverter < Converter
    safe true
    priority :low
    
    def matches(ext)
      ext =~ /scss/i
    end
    
    def output_ext(ext)
      ".css"
    end
    
    def convert(content)
      begin
        require 'compass'

        options = {
          :syntax => :scss, 
          :style => :compact, 
          :load_paths => Compass.configuration.sass_load_paths
        }
        Sass::Engine.new(content, options).render
      rescue StandardError => e
        puts "[Sass Error] #{e.message}"
      end
    end
  end
end