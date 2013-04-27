# -*- encoding: utf-8 -*-
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
      tag_file_name = Tag.tag2filename(tag)
      tag_display_name = Tag.tag2displayname(site.config, lang, tag)

      @site = site
      @base = base
      @name = "index.html"
      @dir = "/#{lang}/blog/tags/#{tag_file_name}"

      self.process(name)
      self.read_yaml(File.join(base, '_layouts'), 'tag.html')

      self.data['tag'] = tag
      self.data['tag_file_name'] = tag_file_name
      self.data['tag_display_name'] = tag_display_name
      self.data['posts'] = posts
      self.data["lang"] = lang

      if lang == 'ja'
        self.data['title'] = "タグ「#{tag_display_name}」の記事一覧"
      else
        self.data['title'] = "Tag: #{tag_display_name}"
      end
    end

    def needs_render?
      @site.yaml_cache.yaml_modified
    end

    def self.tag2filename(name)
      name.downcase.gsub(' ', '-')
    end

    def self.tag2displayname(config, lang, name)
      filename = self.tag2filename(name)
      text = Jekyll::Locales.translate(config, lang, filename)
      text = name if text.start_with? "(UNKNOWN TEXT: "
      return text
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
