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
      File.open(path, 'w') do |f|
        f.write(self.output)
      end
    end
  end
end