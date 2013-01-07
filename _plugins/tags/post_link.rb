# Post Link Plugin for Jekyll
# ===========================
#
# How to use
# ----------
#
#     {% post_link /2012/01/02/article-name.html %}
#     => <a href="/2012/01/02/article-name.html">Article Title</a>
#
#     {% post_link 2012-01-02-article-name %}
#     => <a href="/2012/01/02/article-name.html">Article Title</a>
#
#     {% post_link 2012-01-02-article-name, here %}
#     => <a href="/2012/01/02/article-name.html">here</a>
#
# License
# -------
#
# Copyright 2012, nitoyon. All rights reserved.
# BSD License.

require 'cgi'
require 'jekyll/tags/post_url'

module Jekyll

  class PostLinkTag < Liquid::Tag
    def initialize(tag_name, markup, tokens)
      super
      params = markup.split(',')
      return if params[0].nil?

      @url = params[0].strip

      if params.size >= 2
        @title = params[1].strip
      end
    end

    def render(context)
      site = context.registers[:site]

      url = @url
      if url.nil?
        raise "no param and post is not defined" unless context['post']
        url = context['post']
      end

      begin
        post = PostComparer.new(url)
      rescue
        post = nil
      end

      site.posts.each do |p|
        if p.url == url || p == post
          title = @title.nil? || @title.empty? ? p.data['title'] : @title
          return %(<a href="#{p.url}">#{CGI.escapeHTML(title)}</a>)
        end
      end
      %(<a href="#{url}">#{CGI.escapeHTML(url)}</a>)
    end
  end
end

Liquid::Template.register_tag('post_link', Jekyll::PostLinkTag)
