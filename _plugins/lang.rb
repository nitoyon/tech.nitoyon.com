# Language Page Plugin
#
# * Get language list from _config.yml
# * Output pages in _lang folder for each languages
#
# Dependent plugins
# * site_ext plugin
# * post_yaml_cache plugin

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
      payload = site_payload

      # process each entries and languages
      entries.each do |f|
        # skip directories
        next if File.directory?(File.join(base, f))

        self.config['lang'].each do |lang|
          # Create new page
          page = LanguagePage.new(self, base, f, lang)

          # Render if post yaml is modified (set by post_yaml_cache plugin)
          self.render_if_modified(page, payload)
          self.pages << page
        end
      end
    end
  end
end
