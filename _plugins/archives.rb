#!/usr/bin/env ruby19
# from https://github.com/BlackBulletIV/blackbulletiv.github.com/blob/master/_plugins/archives.rb

require_relative 'custom_page'
 
module Jekyll
  class Archive < CustomPage
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
      time = Time.new(year, month, day)
      
      if day
        dir = time.strftime("/#{lang}/blog/%Y/%m/%d")
      elsif month
        dir = time.strftime("/#{lang}/blog/%Y/%m")
      else
        dir = time.strftime("/#{lang}/blog/%Y")
      end
      
      super site, base, dir, 'archive'
      title = "Archives for "
      
      if day
        title += "#{time.strftime('%B %d, %Y')}"
      elsif month
        title += "#{time.strftime('%B %Y')}"
      else
        title += year.to_s
      end
      
      self.data["title"] = title
      self.data["posts"] = posts.reverse
      self.data["lang"] = lang;
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

    def generate_archives_for_lang(lang)
      years, months = Archive.archives(self.categories[lang])
      
      months.each do |year, m|
        write_page Archive.new(self, self.source, years[year], lang, year)
        
        m.each do |month, d|
          write_page Archive.new(self, self.source, months[year][month], lang, year, month)
        end
      end
    end
  end
end
