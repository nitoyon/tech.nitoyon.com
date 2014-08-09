# Post class for building multiple(or multilingual) blog using category.
#
# This plugin modifies Post.next and Post.previous methods to point 
# prev/next post in the same category.

module Jekyll
  class Post
    # returns 'lang' attribute in YAML header.
    def lang
      if self.data.has_key?('lang')
        self.data['lang']
      else
        warn "#{self.slug} has no lang!!!"
        "en"
      end
    end

    # override default `categories' accessor
    #def categories
    #  [self.lang]
    #end

    def next
      if @has_next_cache
        return @next_cache
      end

      category = self.site.categories[self.lang]
      pos = category.index(self)

      if pos && pos < category.length-1
        @next_cache = category[pos+1]
      else
        @next_cache = nil
      end
      @has_next_cache = true
      @next_cache
    end

    def previous
      if @has_previous_cache
        return @previous_cache
      end

      category = self.site.categories[self.lang]
      pos = category.index(self)

      if pos && pos > 0
        @previous_cache = category[pos-1]
      else
        @previous_cache = nil
      end
      @has_previous_cache = true
      @previous_cache
    end
  end
end