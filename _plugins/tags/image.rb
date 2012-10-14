# Post Link Plugin for Jekyll
# ===========================
#
# How to use
# ----------
#
# Format:
#     {% image URL, Original Width, Original Height, Link URL %}
#
# Example:
#     {% image http://farm9.staticflickr.com/8476/8086011433_ab8bb44953.jpg, 985, 807 %}
#     => <center><img src="..." width="500" height=""></center>
#
# License
# -------
#
# Copyright 2012, nitoyon. All rights reserved.
# BSD License.

module Jekyll

  class ImageTag < Liquid::Tag
    def initialize(tag_name, markup, tokens)
      super
      params = markup.split(',')
      @markup = markup
      if params.length >= 3
        @url = params.shift.strip
        @original_width = params.shift.strip.to_i
        @original_height = params.shift.strip.to_i
        @link_to = params.shift if params.length > 0
      end
    end

    def render(context)
      if @url.nil?
        "(invalid parameter #{@markup})"
      else
        l = [@original_width, @original_height].max
        w = (500.0 * @original_width / l).round
        h = (500.0 * @original_height / l).round

        if @link_to.nil?
          %(<center><img src="#{@url}" width="#{w}" height="#{h}"></center>)
        else
          %(<center><a href="#{@link_to}"><img src="#{@url}" width="#{w}" height="#{h}"></a></center>)
        end
      end
    end
  end
end

Liquid::Template.register_tag('image', Jekyll::ImageTag)
