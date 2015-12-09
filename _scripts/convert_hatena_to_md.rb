# coding: utf-8
# はてな記法のポストを Markdown に変換
# ====================================
#
# convert_hatena_to_jekyll_posts.rb で作成したポストを Markdown 形式に変換します。
#
# 実行例:
#     ruby convert_hatena_to_md.rb _posts/YYYY-MM-DD-entry.htn
#     ruby -I ..\..\..\hotchpotch\hparser\lib convert_hatena_to_md.rb ..\_posts\ja\*.htn

require 'hparser'

# 変換オプション
opt = {
  :fenced_code_blocks => true,
  :tables => true,
  :definition_lists => false,
  :footnotes => true,
  :autolink => false,
}

# 出力の拡張子
out_ext = "htn"

# ** が # になるようにする
HParser::Block::Head::head_level = 0


# コマンドライン引数を読み取り
if ARGV.length < 1
  abort "USAGE: ruby $0 [post]"
end

def main(post, opt, out_ext)
  if File::extname(post) != '.htn'
    abort "extension should be .htn"
  end

  out = post.dup
  out[-3..-1] = out_ext

  content = File.read(post, encoding: 'utf-8')
  data = nil

  if content =~ /\A(---\s*\n.*?\n?)^((---|\.\.\.)\s*$\n?)/m
    content = $'
    data = $1 + "---\n"
  end

  parser = HParser::Parser.new
  md = parser.parse(content).map {|e| e.to_md(opt) }.join("\n")

  open(out, "w") {|f| f.write(data + md)}
  if out != post
    File::delete(post)
  end
  puts "#{post} -> #{out}"
end

ARGV.each {|fn| main(fn, opt, out_ext) }
