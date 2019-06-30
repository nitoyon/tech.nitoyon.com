# Language Page Plugin
#
# * Get language list from _config.yml
# * Output pages in _lang folder for each languages
#
# Dependent plugins
# * post_multilang_by_category plugin

module Jekyll
  class LanguagePage < Page
    def initialize(site, base, name, lang)
      super site, base, '', name
      self.data["lang"] = lang
      self.data['permalink'] = "/#{lang}/#{name}"
    end
  end
  
  class LanguagePageGenerator < Generator
    def generate(site)
      # check config
      unless site.config.has_key? 'lang' and site.config['lang'].instance_of? String
        puts "language is not defined in _config.yml."
        return
      end

      base = File.join(site.source, '_lang')
      return unless File.exists?(base)
      entries = Dir.chdir(base) { site.reader.filter_entries(Dir['**/*']) }
      payload = site.site_payload

      # process each entries and languages
      entries.each do |f|
        # skip directories
        next if File.directory?(File.join(base, f))

        # Create new page
        page = LanguagePage.new(site, base, f, site.config['lang'])

        # Render if post yaml is modified (set by post_yaml_cache plugin)
        site.pages << page
      end
    end
  end
end
