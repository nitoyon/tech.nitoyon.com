#!/usr/bin/env ruby19
#
# Generate yearly and monthly archive page
#
# based on https://github.com/BlackBulletIV/blackbulletiv.github.com/blob/master/_plugins/archives.rb
#
# Change log
# * Works as a Generator
# * Stopped generating daily archive

module Jekyll
  class Archive < Page
    # Generate years and months list by posts
    def self.archives(posts)
      years = Hash.new { |h, k| h[k] = Array.new }
      
      months = Hash.new do |h, k|
        h[k] = Hash.new { |h, k| h[k] = Array.new }
      end
      
      posts.docs.each do |post|
        if post.class != Document then
          puts "#{post} is not Document (#{post.class})"
          next
        end

        d = post.date
        years[d.year] << post
        months[d.year][d.month] << post 
      end
      
      [years, months]
    end
    
    def initialize(site, posts, year, month = nil, day = nil)
      @site = site
      @name = "index.html"

      raise Errors::FatalException.new("lang is not defined. override " +
        "_config.yml with _config.[lang].yml!") unless site.config.key?('lang')
      lang = site.config['lang']
      time = Time.new(year, month, day)
      if day
        @dir = time.strftime("/#{lang}/blog/%Y/%m/%d")
      elsif month
        @dir = time.strftime("/#{lang}/blog/%Y/%m")
      else
        @dir = time.strftime("/#{lang}/blog/%Y")
      end

      self.process(@name)
      self.read_yaml(File.join(site.source, '_layouts'), 'archive.html')

      if day
        title = Jekyll::Locales.translate(site, lang,
          'archive.title.day', 'Archives for %B %d, %Y', time)
      elsif month
        title = Jekyll::Locales.translate(site, lang,
          'archive.title.month', 'Archives for %B %Y', time)
      else
        title = Jekyll::Locales.translate(site, lang,
          'archive.title.year', 'Archives for %Y', time)
      end
      
      self.data["title"] = title
      self.data["posts"] = posts
      self.data["lang"] = lang
    end
  end
  
  class ArhivePageGenerator < Generator
    def generate(site)
      @site = site

      years, months = Archive.archives(@site.posts)
      payload = @site.site_payload

      months.each do |year, m|
        page = Archive.new(@site, years[year], year)
        @site.pages << page

        m.each do |month, d|
          page = Archive.new(@site, months[year][month], year, month)
          @site.pages << page
        end
      end
    end
  end
end
