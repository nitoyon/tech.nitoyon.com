# -*- encoding: utf-8 -*-

# Amazon Tag Plugin for Jekyll
# ============================
#
# How to use
# ----------
#
#   1. Install this script to `_plugin` folder.
#   2. Create cache directory `_caches/amazon`.
#   3. Install amazon/ecs(`gem install amazon-ecs`).
#
# Embed amazon
# ------------
#
#     {% amazon jp:B000002JC2:title %}
#     => <a href="...">Book title</a>
#
#     {% amazon jp:B000002JC2:detail %}
#     => <div class="hatena-asin-detail">
#          <a href="...">Book title</a>
#          <div class="hatena-asin-detail-info">
#             :
#          </div>
#        </div>
#
# License
# -------
#
# Copyright 2012, nitoyon. All rights reserved.
# BSD License.

module Jekyll

  class AmazonTag < Liquid::Tag
    def initialize(tag_name, params, tokens)
      super
      params = params.strip
      if /^(\w+):(\w+):(title|detail)$/.match(params)
        @lang = $1
        @amazon_id = $2
        @type =$3
      end
    end

    def render(context)
      if @lang.nil?
        "(invalid amazon tag parameter)"
      elsif @type == "title"
        data = load_product_data(@lang, @amazon_id, context)
        data[:title]
      elsif @type == "detail"
        data = load_product_data(@lang, @amazon_id, context)
        %(<div class="hatena-asin-detail">
  <a href="#{data[:detailUrl]}"><img src="#{data[:mediumThumnail]}" class="hatena-asin-detail-image" alt="#{data[:title]}" title="#{data[:title]}"></a>
  <div class="hatena-asin-detail-info">
    <p class="hatena-asin-detail-title"><a href="#{data[:detailUrl]}">#{data[:title]}</a></p>
    <ul>
      <li><span class="hatena-asin-detail-label">作者:</span> #{data[:author]}</li>
      <li><span class="hatena-asin-detail-label">出版社/メーカー:</span> #{data[:publisher]}</li>
      <li><span class="hatena-asin-detail-label">発売日:</span> #{data[:date]}</li>
      <li><span class="hatena-asin-detail-label">メディア:</span> #{data[:media]}</li>
    </ul>
  </div>
  <div class="hatena-asin-detail-foot"></div>
</div>)
      else
        "(invalid type)"
      end
    end

    def load_product_data(lang, amazon_id, context)
      doc = load_product_with_cache(lang, amazon_id, context)

      data = {
        :detailUrl =>  doc.elements['/Item/DetailPageURL'].text,
        :mediumThumnail => doc.elements['//MediumImage/URL'].text,
        :title => doc.elements['//ItemAttributes/Title'].text,
        :author => doc.elements['//ItemAttributes/Author'].text,
        :publisher => doc.elements['//ItemAttributes/Manufacturer'].text,
        :date => doc.elements['//ItemAttributes/PublicationDate'].text,
        :media => doc.elements['//ItemAttributes/Binding'].text,
      }
    end

    def load_product_with_cache(lang, amazon_id, context)
      caches_dir = File.join(context.registers[:site].source, '_caches/amazon')
      cache_path = File.join(caches_dir, "#{lang}.#{amazon_id}.xml")
      unless FileTest.directory?(caches_dir)
        puts "Cache directory doesn't exist: #{caches_dir}"
        raise "Cache directory doesn't exist: #{caches_dir}"
      end

      doc = nil
      if FileTest.file?(cache_path)
        open(cache_path) { |f| doc = REXML::Document.new(f.read) }
      end

      if doc.nil?
        puts "load"
        xml_str = load_product_from_web(lang, amazon_id)
        doc = REXML::Document.new(xml_str)
        open(cache_path, 'w') { |f| f.write(xml_str) }
      end

      doc
    end

    def load_product_from_web(lang, amazon_id)
      require 'amazon/ecs'

      Amazon::Ecs.options = {
        :associate_tag => 'nitoyoncom-22',
        :AWS_access_key_id => 'AKIAJ3X4TN77KIHAF67Q',
        :AWS_secret_key => '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'
      }

      # options provided on method call will merge with the default options
      res = Amazon::Ecs.item_lookup(amazon_id, :country => lang, :response_group => 'Images,ItemAttributes')

      if res.has_error?
        ""
      else
        res.doc.xpath('//Items/Item').to_s
      end
    end
  end
end

Liquid::Template.register_tag('amazon', Jekyll::AmazonTag)
