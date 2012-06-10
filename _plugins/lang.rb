#!/usr/bin/env ruby19
# Language Page Plugin
# * Get language list from _config.yml
# * Output pages in _lang folder for each languages

module Jekyll
  class LanguagePage < Page
    def initialize(site, base, name, lang)
      super site, base, '', name
      self.data["lang"] = lang
      self.data['permalink'] = "/#{lang}/#{name}"
    end
  end
  
  class Site
    def generate_languages
      # check config
      unless self.config.has_key? 'lang' and self.config['lang'].instance_of? Array
        puts "language list is not defined in _config.yml."
        return
      end

      base = File.join(self.source, '_lang')
      return unless File.exists?(base)
      entries = Dir.chdir(base) { filter_entries(Dir['**/*']) }

      # first pass processes, but does not yet render post content
      entries.each do |f|
        f_abs = File.join(base, f)
        next if File.directory?(f_abs)
        puts "lang: #{f} #{f_abs}"
        self.config['lang'].each do |lang|
          write_page LanguagePage.new(self, base, f, lang)
        end
      end
    end
  end
end
