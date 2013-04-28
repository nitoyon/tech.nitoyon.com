#!/usr/bin/env ruby19
#
# Generate yearly and monthly archive page
#
# from https://github.com/BlackBulletIV/blackbulletiv.github.com/blob/master/_plugins/archives.rb
#
# Change log
# * Multilang support
# * Stopped generating daily archive
# * Generate only when YAML changed
#
# Dependent plugins
# * site_ext plugin
# * post_multilang_by_category plugin
# * post_yaml_cache plugin

module Jekyll
  class Archive < Page
    # Generate years and months list by posts
    def self.archives(posts)
      years = Hash.new { |h, k| h[k] = Array.new }
      
      months = Hash.new do |h, k|
        h[k] = Hash.new { |h, k| h[k] = Array.new }
      end
      
      posts.each do |post|
        d = post.date
        years[d.year] << post
        months[d.year][d.month] << post 
      end
      
      [years, months]
    end
    
    def initialize(site, base, posts, lang, year, month = nil, day = nil)
      @site = site
      @base = base
      @name = "index.html"

      time = Time.new(year, month, day)
      if day
        @dir = time.strftime("/#{lang}/blog/%Y/%m/%d")
      elsif month
        @dir = time.strftime("/#{lang}/blog/%Y/%m")
      else
        @dir = time.strftime("/#{lang}/blog/%Y")
      end

      self.process(@name)
      self.read_yaml(File.join(base, '_layouts'), 'archive.html')

      if day
        title = Jekyll::Locales.translate(site.config, lang,
          time, 'archive.title.day', 'Archives for %B %d, %Y')
      elsif month
        title = Jekyll::Locales.translate(site.config, lang,
          time, 'archive.title.month', 'Archives for %B %Y')
      else
        title = Jekyll::Locales.translate(site.config, lang,
          time, 'archive.title.year', 'Archives for %Y')
      end
      
      self.data["title"] = title
      self.data["posts"] = posts.reverse
      self.data["lang"] = lang;
    end

    def needs_render?
      self.data["posts"].each { |post|
        return true if post.yaml_modified
      }
      false
    end
  end
  
  class Site
    def generate_archives
      # check config
      unless self.config.has_key? 'lang' and self.config['lang'].instance_of? Array
        puts "language list is not defined in _config.yml."
        return
      end

      self.config['lang'].each do |lang|
        self.generate_archives_for_lang(lang)
      end
    end

    # Generate yearly and monthly archive page of lang
    def generate_archives_for_lang(lang)
      years, months = Archive.archives(self.categories[lang])
      payload = site_payload

      months.each do |year, m|
        page = Archive.new(self, self.source, years[year], lang, year)
        self.render_if_modified(page, payload)
        self.pages << page

        m.each do |month, d|
          page = Archive.new(self, self.source, months[year][month], lang, year, month)
          self.render_if_modified(page, payload)
          self.pages << page
        end
      end
    end
  end
end
