module Jekyll
  module SimplifyRssFilters
    # Simplify RSS description.
    #
    # Remove <span class='xxx'>xxx</span> from input string.
    #
    # input - HTML.
    #
    # Returns the simplified String.
    def simplify_rss_description(input)
      input.gsub(/<span class="([^"]+)">([^<]*)<\/span>/) {$2}
    end
  end
end

Liquid::Template.register_filter(Jekyll::SimplifyRssFilters)
