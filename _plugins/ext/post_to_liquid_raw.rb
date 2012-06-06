# modify Post.to_liquid method to refer Post instance in liquid template.
#
# For eample: Post.content method is evaluated at runtime.
#   {{ page.raw.content }}

module Jekyll
  class Post
    alias :to_liquid_orig :to_liquid unless self.instance_methods.include?(:to_liquid_orig)

    # returns 'lang' attribute in YAML header.
    def to_liquid
      self.to_liquid_orig.deep_merge({
        "raw" => self
      })
    end
  end
end