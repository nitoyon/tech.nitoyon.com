# Post class for building multiple(or multilingual) blog using category.
#
# This plugin modifies Post.next and Post.previous methods to point 
# prev/next post in the same category.

module Jekyll
  class Post
    def next
      if self.categories.length != 1
        warn "category(=lang) value is invalid"
        return nil
      end
      category = self.site.categories[self.categories[0]]
      pos = category.index(self)

      if pos && pos < category.length-1
        category[pos+1]
      else
        nil
      end
    end

    def previous
      if self.categories.length != 1
        warn "category(=lang) value is invalid"
        return nil
      end
      category = self.site.categories[self.categories[0]]
      pos = category.index(self)

      if pos && pos > 0
        category[pos-1]
      else
        nil
      end
    end
  end
end