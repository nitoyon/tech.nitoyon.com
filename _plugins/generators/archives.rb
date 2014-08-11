#!/usr/bin/env ruby19
#
# Generate yearly and monthly archive page
#
# based on https://github.com/BlackBulletIV/blackbulletiv.github.com/blob/master/_plugins/archives.rb
#
# Change log
# * Works as a Generator
# * Multilang support
# * Stopped generating daily archive
#
# Dependent plugins
# * post_multilang_by_category plugin

module Jekyll
  class Archive < Page
    # Generate years and months list by posts
    def self.archives(posts)
      years = Hash.new { |h, k| h[k] = Array.new }
      
      months = Hash.new do |h, k|
        h[k] = Hash.new { |h, k| h[k] = Array.new }
      end
      
      posts.each do |post|
        if post.class != Post then
          puts "#{post} is not Post (#{post.class})"
          next
        end

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
          'archive.title.day', 'Archives for %B %d, %Y', time)
      elsif month
        title = Jekyll::Locales.translate(site.config, lang,
          'archive.title.month', 'Archives for %B %Y', time)
      else
        title = Jekyll::Locales.translate(site.config, lang,
          'archive.title.year', 'Archives for %Y', time)
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
  
  class ArhivePageGenerator < Generator
    def generate(site)
      @site = site

      # check config
      unless @site.config.has_key? 'lang' and @site.config['lang'].instance_of? Array
        puts "language list is not defined in _config.yml."
        return
      end

      @site.config['lang'].each do |lang|
        self.generate_archives_for_lang(lang)
      end
    end

    # Generate yearly and monthly archive page of lang
    def generate_archives_for_lang(lang)
      years, months = Archive.archives(@site.categories[lang])
      payload = @site.site_payload

      months.each do |year, m|
        page = Archive.new(@site, @site.source, years[year], lang, year)
        @site.pages << page

        m.each do |month, d|
          page = Archive.new(@site, @site.source, months[year][month], lang, year, month)
          @site.pages << page
        end
      end
    end
  end
end
