# Flickr Image Plugin for Jekyll
# ==============================
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
# Bookmarklet
# -----------
# Embed original size. Open photo page in flickr and use this bookmarklet.
#
#     javascript:(function(){var d=document;prompt('',d.getElementById("share-op
#     tions-embed-textarea-o").value.replace(/.*src="([^"]+).*/,"{% image $1, ")+
#     d.getElementById("share-options-embed-textarea-o").value.replace(/.*width=
#     "(\d+)" height="(\d+)".*/,'$1, $2 %}'))})()
#
# Embed resized size. Open photo page in flickr and use this bookmarklet.
#
#     javascript:(function(){var d=document;prompt('',d.getElementById("share-op
#     tions-embed-textarea").value.replace(/.*src="([^"]+).*/,"{% image $1, ")+
#     d.getElementById("share-options-embed-textarea-o").value.replace(/.*width=
#     "(\d+)" height="(\d+)".*/,'$1, $2 %}'))})()
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
      img = ""
      if @url.nil?
        return "(invalid parameter #{@markup})"
      elsif @url =~ /_o\.(jpg|png)/
        img = %(<img src="#{@url}" width="#{@original_width}" height="#{@original_height}">)
      else
        l = [@original_width, @original_height].max
        w = (500.0 * @original_width / l).round
        h = (500.0 * @original_height / l).round

        img = %(<img src="#{@url}" width="#{w}" height="#{h}">)
      end

      if @link_to.nil?
        %(<center>#{img}</center>)
      else
        %(<center><a href="#{@link_to}">#{img}</a></center>)
      end
    end
  end
end

Liquid::Template.register_tag('image', Jekyll::ImageTag)
