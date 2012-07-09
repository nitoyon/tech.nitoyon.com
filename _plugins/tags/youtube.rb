# Tweet Tag Plugin for Jekyll
# ===========================
#
# How to use
# ----------
#
#   1. Install this script to `_plugin` folder.
#   2. Create cache directory `_caches/tweet`.
#
# Embed tweet
# -----------
#
#     {% tweet https://twitter.com/twitterapi/status/136541709390708736 %}
#     {% tweet 136541709390708736 %}
#
# License
# -------
#
# Copyright 2012, nitoyon. All rights reserved.
# BSD License.

module Jekyll

  class YouTubeTag < Liquid::Tag
    def initialize(tag_name, id, tokens)
      super
      @id = id.strip
    end

    def render(context)
      %(<iframe class="youtube" width="480" height="360" src="http://www.youtube.com/embed/#{@id}" frameborder="0" allowfullscreen></iframe>)
    end
  end
end

Liquid::Template.register_tag('youtube', Jekyll::YouTubeTag)
