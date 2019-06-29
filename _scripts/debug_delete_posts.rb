# coding: utf-8
# 一時的にポストを削除するスクリプト
# ==================================
# _posts から指定されたルールにマッチするもの以外を削除します
# _site から指定されたルールにマッチする記事以外を削除します
#
# (ex)
# > cd tech.nitoyon.com
# > ruby _scripts/debug_delete_posts.rb ja 2016 01

# コマンドライン引数を読み取り
if ARGV.length < 2
    abort "USAGE: ruby $0 [ja | en] year month"
end

lang = ARGV[0]
year = ARGV[1]
month = ARGV[2]

# _posts から指定されたもの以外を削除する
matched = Dir::glob("_posts/#{lang}/#{year}-#{month}-*")
puts "Matched posts: #{matched}"
Dir::glob("_posts/*/*").each { |file|
    if matched.include?(file)
        puts "skipping #{file}"
    else
        puts "deleting #{file}"
        File.delete file
    end
}

# _site から指定されたもの以外を削除する
matched = Dir::glob("_site/#{lang}/blog/#{year}/#{month}/*/*/index.html")
puts "Matched site: #{matched}"
Dir::glob("_site/{ja,en}/blog/*/*/*/*/index.html").each { |file|
    if matched.include?(file)
        puts "skipping #{file}"
    else
        puts "deleting #{file}"
        File.delete file
    end
}

# _site から指定された HTML を整形する
puts "Formatting..."
system("node _scripts/format_html.js _site/#{lang}/blog/#{year}/#{month}/*/*/index.html")
