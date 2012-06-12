# Convert '*.htn' to HTML with Hatena Style
#
# hparser(at https://github.com/nitoyon/hparser/tree/nitoyon) required

module Jekyll

  class HatenaConverter < Converter
    safe true

    priority :low

    def matches(ext)
      ext =~ /htn/i
    end

    def output_ext(ext)
      ".html"
    end

    def convert(content)
      require 'hparser'

      ### HTML 変換の設定 ###
      # ** が H1 になるようにする
      HParser::Block::Head::head_level = 0

      # _config.yml で pygments を true にしているときは、スーパー pre 記法も
      # Pygments を使ってハイライトする
      if @config['pygments']
        HParser::Block::SuperPre::use_pygments = true
      end

      parser = HParser::Parser.new
      parser.parse(content).map {|e| e.to_html }.join("\n")
    end

  end
end