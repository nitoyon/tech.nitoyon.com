module Jekyll
  module Filters
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
      lang = 'en'
      lang = @context['page']['lang'] if @context['page'].has_key?('lang')
      config = @context.registers[:site].config
      Jekyll::Tag.tag2displayname(config, lang, input)
    end
  end
end
