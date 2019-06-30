module Jekyll
  module TagFilter
    # Convert tag name to URL
    #
    # input - text
    #
    # Liquid:
    #     {{'Google Maps' | tag2filename }}
    #     # => 'google-maps'
    def tag2filename(name)
      Jekyll::Tag.tag2filename(name)
    end

    # Convert tag name to display text using locale file.
    #
    # input - text.
    #
    # _config.yml file:
    #     locale:
    #       en:
    #         blog: "BLOG BLOG BLOG"
    #
    # Liquid:
    #     {{'blog' | tag2displayname}}
    #     # => 'BLOG BLOG BLOG'
    #
    # Returns the translated String "BLOG BLOG BLOG".
    # If there's no entry in the locale file, returns the given text.
    def tag2displayname(input)
      site = @context.registers[:site]
      lang = site.config['lang']
      Jekyll::Tag.tag2displayname(site, lang, input)
    end
  end
end

Liquid::Template.register_filter(Jekyll::TagFilter)
