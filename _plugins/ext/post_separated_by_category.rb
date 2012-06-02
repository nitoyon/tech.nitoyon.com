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
    def categories
      [self.lang]
    end

    def next
      category = self.site.categories[self.lang]
      pos = category.index(self)

      if pos && pos < category.length-1
        category[pos+1]
      else
        nil
      end
    end

    def previous
      category = self.site.categories[self.lang]
      pos = category.index(self)

      if pos && pos > 0
        category[pos-1]
      else
        nil
      end
    end
  end
end