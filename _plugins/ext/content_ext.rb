# Add page.converted_content to Convertible
# =========================================
#
# By default, Liquid layout file cannot get converted content except for the
# layout specified by the page or post.
#
# This plugin enables to refer converted content.
#
#     {{ post.converted_content }}

module Jekyll
  module Convertible
    alias :render_all_layouts_orig :render_all_layouts unless self.instance_methods.include?(:render_all_layouts_orig)

    def render_all_layouts(layouts, payload, info)
      @converted_content = content
      payload["page"]["converted_content"] = content
      self.render_all_layouts_orig(layouts, payload, info)
    end
  end

  class Post
    attr_accessor :converted_content

    ATTRIBUTES_FOR_LIQUID.push 'converted_content'
  end
end