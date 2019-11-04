# Post Link Plugin for Jekyll
# ===========================
#
# How to use
# ----------
#
# This tag enables you to create a link to a page or post by specifying
# one of following
#    * URL
#    * category name and file name
#    * file name
#    * variable (name should be 'post')
#
# Embed with URL.
#
#     {% post_link /category/2012/01/02/article-name.html %}
#     => <a href="/category/2012/01/02/article-name.html">Article Title</a>
#
# Embed with category name and file name.
#
#     {% post_link category/2012-01-02-article-name %}
#     => <a href="/category/2012/01/02/article-name.html">Article Title</a>
#
# Specify link text
#
#     {% post_link 2012-01-02-article-name, here %}
#     => <a href="/2012/01/02/article-name.html">here</a>
#
# Use post variable: post variable (instance of Post class) should be defined
#     {% post_link %}
#     => <a href="/category/2012/01/02/article-name.html">Article Title</a>
#
# License
# -------
#
# Copyright 2012, nitoyon. All rights reserved.
# BSD License.

require 'cgi'

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
      url = '/' + url unless url.start_with? '/'

      # Find post or page
      post = nil
      (site.posts.docs + site.pages).each do |p|
        post_url = p.url
        post_url = p.cleaned_relative_path if p.class == Document
        post_url_without_lang = post_url.sub(/^.*\//, '/')
        if post_url == url || post_url_without_lang == url
          # stop enumerating if url exactly matches
          post = p
          break
        end
      end

      if post.nil?
        %(<a href="#{url}">#{CGI.escapeHTML(url)}</a>)
      else
        title = @title.nil? || @title.empty? ? post.data['title'] : @title
        %(<a href="#{post.url}">#{CGI.escapeHTML(title)}</a>)
      end
    end
  end
end

Liquid::Template.register_tag('post_link', Jekyll::PostLinkTag)
