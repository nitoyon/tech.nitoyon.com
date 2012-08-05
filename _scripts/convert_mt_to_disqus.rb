# -*- encoding: utf-8 -*-

# Import movable type comments to DISQUS
# ======================================
#
# Import comments from Movable type export format to DISQUS.
#
# This script doesn't write `link` and `dsq:thread_identifier`.
#
# example:
#     # import file.txt, timezone 0
#     ruby convert_mt_to_disqus.rb file.txt 0
#
#     # import file.txt, timezone +9
#     ruby convert_mt_to_disqus.rb file.txt +9
#
#     # import file.txt, timezone 0, Jekyll posts is ./_posts
#     ruby convert_mt_to_disqus.rb file.txt 0 ./_posts
#
# reference:
#     http://help.disqus.com/customer/portal/articles/472150-custom-xml-import-format

# true if exported Hatena diary
#$is_hatena = false
$is_hatena = true

# identifier prefix
#$id_prefix = "/"
$id_prefix = "/ja/blog/"

# URL domain
$site_domain = "http://tech.nitoyon.com"



require 'rexml/document'

def main(mt_path, timezone, posts_dir)
  # Open file
  mt = File.new(mt_path).read
  entries = mt.split("\n--------\n").map { |e|
    parse_entry(e, timezone)
  }

  output_xml(entries, posts_dir)
end

def parse_entry(entry, timezone)
  ret = { :comment => [] }

  parts = entry.split("-----\n")
  parts.each { |part|
    next unless part =~ /^(AUTHOR|COMMENT):/

    if part.start_with?("AUTHOR:")
      ret[:title] = convert_text($1) if part =~ /^TITLE: (.*)$/
      ret[:date] = convert_date($1, 0) if part =~ /^DATE: (.*)$/
    else
      comment = {}
      comment[:author] = convert_text($1) if part =~ /^AUTHOR: (.*)$/
      comment[:url] = $1 if part =~ /^URL: (.*)$/
      comment[:date] = convert_date($1, timezone) if part =~ /^DATE: (.*)$/
      comment[:content] = convert_text($1) if part =~ /\nDATE: [0-9: AMP\/]*\n(.*)\n/m
      ret[:comment] << comment
    end
  }

  ret
end

def convert_text(text)
  if $is_hatena
    text = text.
      gsub("<br>", "\n").
      gsub("&lt;", "<").
      gsub("&gt;", ">").
      gsub("&amp;", "&").
      gsub("&#39;", "'").
      gsub("&#187;", "»").
      gsub("&#65535;", "")
  end
  text
end

def convert_date(date, timezone)
  unless date =~ /^(\d{2})\/(\d{2})\/(\d{4}) (\d{2}):(\d{2}):(\d{2}) (A|P)M/
    raise "invalid date #{date}"
  end
  t = Time.gm($3.to_i, $1.to_i, $2.to_i, $4.to_i, $5.to_i, $6.to_i)
  t = t + 12 * 60 * 60 if $7 == 'P'
  t - timezone * 60 * 60
end

def output_xml(entries, posts_dir)
  doc = REXML::Document.new %(<?xml version="1.0" encoding="UTF-8"?>
<rss version="2.0"
  xmlns:content="http://purl.org/rss/1.0/modules/content/"
  xmlns:dsq="http://www.disqus.com/"
  xmlns:dc="http://purl.org/dc/elements/1.1/"
  xmlns:wp="http://wordpress.org/export/1.0/">
  <channel/>
</rss>)

  num = 1

  entries.each { |entry|
    next if entry[:comment].empty?

    name = get_entry_id(entry[:title], entry[:date], posts_dir)
    identifier = ""
    url = ""
    if name.nil?
        puts "Name not found: #{entry[:title]} #{entry[:date]}" unless posts_dir.nil?
    else
        identifier = $id_prefix + entry[:date].strftime("%Y/%m/%d/") + name + "/"
        url = $site_domain + identifier
    end

    item = REXML::Element.new "item"
    item.add_element("title").text = entry[:title]
    item.add_element("link").text = url
    item.add_element("content:encoded").text = ""
    item.add_element("dsq:thread_identifier").text = identifier
    item.add_element("wp:post_date_gmt").text = entry[:date].strftime "%Y-%m-%d %H:%M:%S"
    item.add_element("wp:comment_status").text = "open"

    entry[:comment].each { |comment|
      c = REXML::Element.new "wp:comment"
      c.add_element("wp:comment_id").text = num.to_s
      c.add_element("wp:comment_author").text = comment[:author]
      c.add_element("wp:comment_author_email")
      c.add_element("wp:comment_author_url").text = comment[:url]
      c.add_element("wp:comment_author_IP")
      c.add_element("wp:comment_date_gmt").text = comment[:date].strftime "%Y-%m-%d %H:%M:%S"
      c.add_element("wp:comment_content").text = REXML::CData.new(comment[:content])
      c.add_element("wp:comment_approved").text = "1"
      c.add_element("wp:comment_parent").text = "0"

      num = num + 1
      item.add_element(c)
    }

    doc.elements["//channel"].add(item)
  }

  doc.write $stdout, 0
end

def get_entry_id(title, date, posts_dir)
  return nil if posts_dir.nil?

  # normalize title
  title = title.gsub('&amp;', '&') if $is_hatena

  files = Dir::glob(posts_dir + "/" + date.strftime("%Y-%m-%d-*"))
  files.each { |file|
    if files.length > 1
      content = File.read(file)
      next unless content.include? "\ntitle: #{title}\n"
    end
    return $1 if file =~ /\d{4}-\d{2}-\d{2}-(.*)(\.[^.]+)$/
  }
  nil
end


if ARGV.length < 2
  abort "USAGE: ruby #{$0} [mt file] [timezone (ex) +9]"
end

mt_path = ARGV[0]
timezone = ARGV[1].to_i
posts_dir = ARGV[2] if ARGV.length == 3

main(mt_path, timezone, posts_dir)
