# Post Link Plugin for Jekyll
# ===========================
#
# How to use
# ----------
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
# Embed with file name. (If there are multiple posts with same file name with
# different category name, it is not undefined that which posts are selected.
#
#     {% post_link 2012-01-02-article-name %}
#     => <a href="/category/2012/01/02/article-name.html">Article Title</a>
#
# Specify link text
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

  # PostCategoryComparer adds `categories` property to PostComparer
  # (defined in lib/jekyll/tags/post_url.rb).
  # Not that Post#<=>() only checks `YYYY-MM-DD-slug` are equal
  class PostCategoryComparer
    MATCHER = /^(.+\/)*(\d+-\d+-\d+)-(.*)$/

    attr_accessor :date, :slug, :categories

    def initialize(name)
      m, dir, date, slug = *name.match(MATCHER)
      dir ||= ""
      @categories = dir.split('/').reject { |x| x.empty? }
      @slug = slug
      @date = Time.parse(date)
    end
  end

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
        target_post = PostCategoryComparer.new(url)
      rescue
        target_post = nil
      end

      # Find post
      post = nil
      site.posts.each do |p|
        if p.url == url
          # stop enumerating if url exactly matches
          post = p
          break
        elsif p == target_post
          post = p
          # stop enumerating if categories are specified and equal
          if p.categories == target_post.categories
            break
          end
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
