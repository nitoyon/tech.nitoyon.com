# extend Post class and Page class
#
# Add properties
# ==============
#
# By default, Post.content changes while rendering:
#     content
#        ↓ render (process templates)
#     content
#        ↓ transform (apply converter)
#     content
#        ↓ layout recursively
#     output
#
# In order to refer intermediate content, this plugin adds following instance
# variables.
#     original_content
#        ↓ render (process templates)
#     rendered_content
#        ↓ transform (apply converter)
#     content
#        ↓ layout recursively
#     output
#
# Post object in Liquid template
# ==============================
#
# By default, Jekyll hides post object to Liquid template.
#
# This plugin enables to refer post object by raw accessor.
#
#     {{ post.raw.original_content }}
#
# Dependent plugins
# =================
#
# * site_ext plugin

module Jekyll
  class ToDrop < Liquid::Drop
    def initialize(obj)
      @obj = obj
    end
    def before_method(method)
      if method && method != '' && @obj.class.public_method_defined?(method.to_s.to_sym)
        @obj.send(method.to_s.to_sym)
      end
    end
  end

  class Post
    alias :to_liquid_orig :to_liquid unless self.instance_methods.include?(:to_liquid_orig)
    attr_accessor :original_content, :rendered_content

    # add 'raw' attribute
    def to_liquid
      self.to_liquid_orig.deep_merge({
        "raw" => ToDrop.new(self)
      })
    end

    def content_force_layout
      unless @layouted
        self.render(self.site.layouts, self.site.site_payload)
      end
      self.content
    end
  end

  class Page
    alias :to_liquid_orig :to_liquid unless self.instance_methods.include?(:to_liquid_orig)

    # add 'raw' attribute
    def to_liquid
      self.to_liquid_orig.deep_merge({
        "raw" => ToDrop.new(self)
      })
    end
  end

  module Convertible
    alias :do_layout_orig :do_layout unless self.instance_methods.include?(:do_layout_orig)
    alias :transform_orig :transform unless self.instance_methods.include?(:transform_orig)

    def do_layout(payload, layouts)
      @original_content = self.content
      self.do_layout_orig(payload, layouts)
      @layouted = true
    end

    def transform
      @rendered_content = self.content
      self.transform_orig
    end
  end
end