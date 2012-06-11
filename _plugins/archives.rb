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
      
      days = Hash.new do |h, k|
        h[k] = Hash.new do |h, k|
          h[k] = Hash.new { |h, k| h[k] = Array.new }
        end
      end
      
      posts.each do |post|
        d = post.date
        years[d.year] << post
        months[d.year][d.month] << post 
        days[d.year][d.month][d.day] << post
      end
      
      [years, months, days]
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
      years, months, days = Archive.archives(self.categories[lang])
      
      days.each do |year, m|
        write_page Archive.new(self, self.source, years[year], lang, year)
        
        m.each do |month, d|
          write_page Archive.new(self, self.source, months[year][month], lang, year, month)
          d.each { |day, posts| write_page Archive.new(self, self.source, posts, lang, year, month, day) }
        end
      end
    end
  end
  
  class MonthlyArchives < Liquid::Tag
    safe = true
    
    def render(context)
      @@list ||= generate_list(context)
    end
    
    private
    
      def generate_list(context)
        years, months, days = Archive.archives(context.registers[:site])
        result = ""
        
        months.each do |year, m|
          m.each do |month, posts|
            time = Time.new(year, month)
            result.insert(0, %(<a href="#{time.strftime('/%Y/%m')}"><strong>#{time.strftime('%B %Y')}</strong></a> (#{posts.length})<br />)) # for reverse order
          end
        end
        
        result
      end
  end
end

Liquid::Template.register_tag('monthly_archives', Jekyll::MonthlyArchives)
