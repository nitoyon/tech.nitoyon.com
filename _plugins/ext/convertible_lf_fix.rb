# Set eol to CRLF on Windows
#
# Jekyll 1.2~, #1364 forces eol to be LF on Windows.
#   * https://github.com/mojombo/jekyll/pull/1364
# 
# This plugin stops this behavior.

module Jekyll
  module Convertible
    def write(dest)
      path = destination(dest)
      FileUtils.mkdir_p(File.dirname(path))

      # temporary fix for reduce diff between hparser and markdown
      output = self.output
        .gsub("\n\n", "\n")
        .gsub(/<meta property="og:description" content="[^"]*"/, %q|<meta property="og:description" content="(snip)"|)
        .gsub(/^<br \/>\n/, "")
        .gsub("\t", "    ")
        .gsub("<p><center>", "<center>")
        .gsub("</center></p>", "</center>")
        .gsub(%q|<div class="highlight"><pre>|, "<pre>")
        .gsub("</pre></div>", "</pre>")
        .gsub(/<pre><code[^>]+>/, "<pre>")
        .gsub("</code></pre>", "</pre>")
        .gsub("\n</pre>", "</pre>")
        .gsub("</p><cite>", "</p><p><cite>")
        .gsub("</cite></blockquote>", "</cite></p></blockquote>")
        .gsub("<table><thead>", "<table>")
        .gsub("</thead><tbody>", "")
        .gsub("</tbody>", "")

      # format
      require 'htmlbeautifier'
      output = HtmlBeautifier.beautify(output, tab_stops: 0)

      File.open(path, 'w') do |f|
        f.write(output)
      end
    end
  end
end