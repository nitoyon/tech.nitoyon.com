# coding: utf-8
# はてなダイアリー Jekyll インポート
# ==================================
#
# はてなダイアリーの「はてなの日記データ形式」でエクスポートしたデータを
# はてな記法のまま Jekyll 形式に変換するスクリプトです。
#
# はてなダイアリーが [ブログモード] で運営されていることを前提とします。
#
# プラグインとして converter/hatena.rb を指定して、hparser を利用することで、
# はてなダイアリーとほぼ同等の出力になります。
#
# 実行例:
#     ruby convert_hatena_to_jekyll_posts.rb nitoyon export.xml
#     # YYYYMMDD/entry_title → _posts/YYYY-MM-DD-entry-title.htn

require 'liquid'
require 'rexml/document'
require 'yaml'

# タイトル省略リンクのタイトルを Web から取得するかどうか
#
# 動作条件
# * nokogiri が必要(gem install nokogiri)
# *_caches フォルダを作っておく
#
# 対象のコンテンツが 404 になっている場合には例外が出てスクリプトが停止します。
# その場合は _caches/url_title.json に手動でエントリを追加する、元のエントリを
# 修正する、などして回避してください。
$enable_html_title_retrieval = true

# インポートしない記事を指定するための正規表現
#
# タイトルに対して評価され、マッチする記事はインポートしません。
$title_ng_regex = /<a/

# デバッグログを出力するかどうか
$debug = false


# コマンドライン引数を読み取り
if ARGV.length < 2
  abort "USAGE: ruby $0 [hatena_id] [XML file]"
end

hatena_id = ARGV[0]
xml_path = ARGV[1]
puts "\nhatena id: #{hatena_id}\nXML path: #{xml_path}\n\n"

def main(hatena_id, xml_path)
  # XML を開く
  file = File.new(xml_path)
  str = file.read.gsub('&#65535;', '')
  doc = REXML::Document.new str

  # 各日ごとに処理
  # <diary>
  #   <day date="YYYY-MM-DD" title="">
  #     <body>...</body>
  #   </day>
# </diary>
  doc.elements.each("/diary/day") { |e|
    parse_day(e, hatena_id)
  }
end

def parse_day(e, hatena_id)
  date = e.attributes["date"]
  body = e.elements["body"].text

  # インポートする期間を制限する場合
  #if date < "2006-01-01" then return end

  # エントリーごとに処理
  # body には複数エントリーが含まれることがある
  # (例)
  #     *p1*エントリー1
  #     あああ
  #     
  #     *p2*エントリー2
  #     あああ
  body.split(/(?=^\*[^\*\/])/).each { |entry|
    if entry.strip == "" then
      next
    end

    # 1 行目がタイトル
    title,text = entry.split(/\n/, 2)
    puts "Parsing #{date} '#{title}'..." if $debug

    # "*name*[tag1][tag2]name_ja" に分解
    # name がないエントリーはスキップする
    unless m = title.match(/^\*([^*]+)\*(?:\[(.*)\])?(.*)/)
        puts "skip: #{title}"
        next
    end
    name = m[1]
    name_ja = m[3]
    tags = m[2].nil? ? [] : m[2].split('][')
    old_url = date.gsub('-', '') + "/" + name
    new_name = name.gsub('_', '-')

    # スキップ条件
    if name_ja =~ $title_ng_regex
        puts "skip: #{title}" if $debug
        next
    end

    # ファイル出力する
    fn = "_posts/#{date}-#{new_name}.htn"
    content = {
      "layout" => "post", 
      "title" => name_ja,
      "tags" => case tags.length
                when 0 then ""
                when 1 then tags[0]
                else tags end,
      "lang" => "ja",
      "old_url" => "http://d.hatena.ne.jp/#{hatena_id}/#{old_url}",
    }.to_yaml + "---\n" + convert_text(text, hatena_id)
    if FileTest.file?(fn) && File.read(fn) == content
      puts "Skip #{fn}" if $debug
    else
      File.open(fn, "w") { |f| f.write(content) }
      puts "Success #{fn}" if $debug
    end
  }
end

def convert_text(text, hatena_id)
    # 本文の {% hoge %} や {{ hoge }}が Liquid テンプレートタグとして解釈
    # されないようにしておく
    tokens = text.split(/(#{Liquid::PartialTemplateParser})/)
    tokens.shift if tokens[0] and tokens[0].empty?
    tokens = tokens.map {|t|
      t = "{%raw%}#{t}{%endraw%}" if t.match(Liquid::AnyStartingTag)
      t
    }
    text = tokens.join("")

    # [twitter:123456789:detail] → {% tweet 123456789 %}
    text = text.gsub(/\[?twitter:(\d+):detail\]?/, '>{% tweet \1 %}<')

    # [twitter:@nitoyon] → {% twitter @nitoyon %}
    text = text.gsub(/\[?twitter:@(\w+)\]?/, '{% twitter @\1 %}')

    # [http://www.youtube.com/watch?v=xxxxxx:movie]
    # → {% youtube xxxxxx %}
    text = text.gsub(/\[http:\/\/www\.youtube\.com\/watch\?v=([^:]+):movie\]/) { |text|
        "{% youtube #{$1} %}"
    }

    # [http://d.hatena.ne.jp/#{hatena_id}/YYYYMMDD/name:title]
    # → {% post_link YYYY-MM-DD-name %}
    text = text.gsub(/\[http:\/\/d\.hatena\.ne\.jp\/#{hatena_id}\/(\d{4})(\d{2})(\d{2})\/([^\]]+):title\]/) { |text|
        "{% post_link #{$1}-#{$2}-#{$3}-#{$4.gsub('_', '-')} %}"
    }

    # HTML の省略されたタイトルを解決する
    if $enable_html_title_retrieval
        text = text.gsub(/[\[>](https?:\/\/.+?):title[^=]/) { |text|
            text[0..-2] + "=" + retrieve_html_title($1) + text[-1]
        }
    end

    # ISBN/ASIN 記法
    # isbn:xxxxx:title → {% amazon jp:xxxxx:title %}
    text = text.gsub(/\[?(?:isbn|asin):(\w+):(title|detail)\]?/) { |text|
      if $2 == "title"
        "{% amazon jp:#{$1}:title %}"
      elsif $2 == "detail"
        ">{% amazon jp:#{$1}:detail %}<"
      else
        "(unknown amazon type #{$2})"
      end
    }

    text
end

def retrieve_html_title(url)
    require 'json'
    require 'open-uri'

    # キャッシュに存在していればキャッシュから読む
    cache_path = '_caches/url_title.json'
    cache = {}
    if FileTest.file? cache_path
        open(cache_path) { |f| cache = JSON.parse(f.read) }
        if cache.key?(url)
            return cache[url]
        end
    end

    # 取得する
    require 'nokogiri'
    puts "open url #{url}"
    doc = Nokogiri::HTML(open(url))
    titles = doc.css("title")
    title = titles.length > 0 ? titles[0].text : url
    title = title.gsub(/\t|\n/, "").strip

    # キャッシュに書く
    cache[url] = title
    open(cache_path, 'w') { |f|
        f.write(JSON.pretty_generate(cache))
    }
    title
end

main(hatena_id, xml_path)
