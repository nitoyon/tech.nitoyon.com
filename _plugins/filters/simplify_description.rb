module Jekyll
  module SimplifyDescriptionFilters
    class StandardFilters
      extend Liquid::StandardFilters
    end

    def simplify_og_description(input)
      input = input.to_s

      # strip before content
      input = input.sub(/.*<ul class="posts">/m, '') # archive, tag
      input = input.sub(/<div class="tag-cloud">/m, '') # tags
      input = input.sub(/.*<div id="entry">/m, '') # post

      # strip after content
      input = input.sub(/<footer>.*/m, '')

      # filter
      input = StandardFilters.strip_newlines(input)
      input = StandardFilters.strip_html(input)
      input = StandardFilters.truncatewords(input, 40)
      input = StandardFilters.truncate(input, 300)
      input = StandardFilters.escape_once(input)
      input.strip
    end

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

Liquid::Template.register_filter(Jekyll::SimplifyDescriptionFilters)
