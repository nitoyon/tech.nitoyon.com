module Jekyll
  module Filters
    # Convert tag name to URL
    def tag2filename(name)
      Jekyll::Tag.tag2filename(name)
    end

    # Convert tag name to display text using locale file.
    #
    # input - text.
    #
    # Liquid:
    #     {{'blog' | tag}}
    #
    # Locale file(_locales/en.yml):
    #     blog: "BLOG BLOG BLOG"
    #
    # Returns the translated String "BLOG BLOG BLOG".
    # If there's no entry in the locale file, returns the given text.
    def tag2display_name(input)
      text = t(tag2filename(input))
      text = input if text.start_with? "(UNKNOWN TEXT: "
      return text
    end
  end
end
