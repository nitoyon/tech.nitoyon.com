# Tweet Tag Plugin for Jekyll
# ===========================
#
# How to use
# ----------
#
#   1. Copy this script into `_plugin` folder.
#
# Embed twitter account
# ---------------------
#
#     {% twitter @nitoyon %}
#     => @<a href="http://twitter.com/nitoyon">nitoyon</a>
#
# License
# -------
#
# Copyright 2012, nitoyon. All rights reserved.
# BSD License.

module Jekyll

  class TwitterTag < Liquid::Tag
    def initialize(tag_name, name, tokens)
      super
      name = name.strip
      @name = name[1 .. -1] if name =~ /^@\w+$/
    end

    def render(context)
      if @name.nil?
        "(invalid twitter account)"
      else
        %(@<a href="http://twitter.com/#{@name}">#{@name}</a>)
      end
    end
  end
end

Liquid::Template.register_tag('twitter', Jekyll::TwitterTag)
