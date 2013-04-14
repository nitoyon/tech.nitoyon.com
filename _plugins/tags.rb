#!/usr/bin/env ruby19
#
# Generate yearly and monthly archive page
#
# from https://github.com/BlackBulletIV/blackbulletiv.github.com/blob/master/_plugins/tags_categories.rb
#
# Change log
# * Multilang support
# * Generate only when YAML changed
#
# Dependent plugins
# * site_ext plugin
# * post_yaml_cache plugin

module Jekyll
  class Tag < Page
    def initialize(site, base, tag, lang, posts)
      @site = site
      @base = base
      @name = "index.html"
      @dir = "/#{lang}/blog/tags/#{Tag.tag2filename(tag)}"

      self.process(name)
      self.read_yaml(File.join(base, '_layouts'), 'tag.html')

      self.data['tag'] = tag
      self.data['posts'] = posts
      self.data["lang"] = lang
    end

    def needs_render?
      @site.yaml_cache.yaml_modified
    end

    def self.tag2filename(name)
      name.downcase.gsub(' ', '-')
    end
  end

  class Site
    def generate_tags
      payload = site_payload

      self.tags.each do |tag, posts|
        lang_posts = {}
        posts.each do |post|
          lang_posts[post.lang] = [] unless lang_posts.key? post.lang
          lang_posts[post.lang] << post
        end

        lang_posts.each do |lang, p|
          page = Tag.new(self, self.source, tag, lang, p)
          self.render_if_modified(page, payload)
          self.pages << page
        end
      end
    end
  end
end
