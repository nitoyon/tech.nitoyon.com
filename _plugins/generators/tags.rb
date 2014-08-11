# -*- encoding: utf-8 -*-
#
# Generate tag page
#
# Change log
# * Multilang support
#
# Dependent plugins
# * post_multilang_by_category plugin

module Jekyll
  class Tag < Page
    def initialize(site, base, tag, lang, posts)
      tag_file_name = Tag.tag2filename(tag)
      tag_display_name = Tag.tag2displayname(site.config, lang, tag)

      @site = site
      @base = base
      @name = "index.html"
      @dir = "/#{lang}/blog/tags/#{tag_file_name}"
      @url = "/#{lang}/blog/tags/#{URI.escape(tag_file_name)}/"

      self.process(name)
      self.read_yaml(File.join(base, '_layouts'), 'tag.html')

      self.data['tag'] = tag
      self.data['tag_file_name'] = tag_file_name
      self.data['tag_display_name'] = tag_display_name
      self.data['posts'] = posts
      self.data["lang"] = lang
      self.data["permalink"] = permalink

      self.data['title'] = Jekyll::Locales.translate(site.config, lang,
        'tag.title', 'Tag: $0', tag_display_name)
    end

    def self.tag2filename(name)
      name.downcase.gsub(' ', '-')
    end

    def self.tag2displayname(config, lang, name)
      filename = self.tag2filename(name)
      Jekyll::Locales.translate(config, lang, filename, name)
    end
  end

  class TagList < Page
    def initialize(site, base, tags, lang)
      @site = site
      @base = base
      @name = "index.html"
      @dir = "/#{lang}/blog/tags"

      self.process(name)
      self.read_yaml(File.join(base, '_layouts'), 'tags.html')

      tag_names = tags.keys.sort {|a, b| a.downcase <=> b.downcase }
      min_posts, max_posts = tags.values.map {|p| p.length}.minmax
      self.data['tags'] = tag_names.map {|name|
        ratio = max_posts == min_posts ? 1 :
          ((tags[name].count.to_f - min_posts) * 100 / (max_posts - min_posts)).to_i
        {'name' => name,
         'posts' => tags[name],
         'cloud' => case ratio
           when 100
             "0"
           when 50..100
             "1"
           when 15 .. 50
             "2"
           when 10 .. 15
             "3"
           when 5 .. 10
             "4"
           else
             "5"
           end
         }
      }
      self.data["lang"] = lang

      self.data['title'] = Jekyll::Locales.translate(site.config, lang,
        'tags.title', 'Tag Cloud')
    end

    def needs_render?
      @site.yaml_cache.yaml_modified
    end
  end

  class TagPageGenerator < Generator
    def generate(site)
      payload = site.site_payload

      lang_tags = {}
      site.tags.each do |tag, posts|
        posts.each do |post|
          lang_tags[post.lang] = {} unless lang_tags.key? post.lang
          lang_tags[post.lang][tag] = [] unless lang_tags[post.lang].key? tag
          lang_tags[post.lang][tag] << post
        end
      end

      lang_tags.each do |lang, tags|
        page = TagList.new(site, site.source, tags, lang)
        site.pages << page

        tags.each do |tag, posts|
          page = Tag.new(site, site.source, tag, lang, posts)
          site.pages << page
        end
      end
    end
  end
end
