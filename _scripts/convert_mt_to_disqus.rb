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
# Todo:
#   * If 3rd argument is specified, Jekyll posts are read and fill these nodes.
#
# reference:
#     http://help.disqus.com/customer/portal/articles/472150-custom-xml-import-format

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
      ret[:title] = $1 if part =~ /^TITLE: (.*)$/
      ret[:date] = convert_date($1, timezone) if part =~ /^DATE: (.*)$/
    else
      comment = {}
      comment[:author] = $1 if part =~ /^AUTHOR: (.*)$/
      comment[:url] = $1 if part =~ /^URL: (.*)$/
      comment[:date] = convert_date($1, timezone) if part =~ /^DATE: (.*)$/
      comment[:content] = $1 if part =~ /\nDATE: [0-9: AMP\/]*\n(.*)/m
      ret[:comment] << comment
    end
  }

  ret
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

    item = REXML::Element.new "item"
    item.add_element("title").text = entry[:title]
    item.add_element("link").text = ""
    item.add_element("content:encoded").text = ""
    item.add_element("dsq:thread_identifier").text = ""
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
      c.add_element("wp:comment_content").text = REXML::CData.new(comment[:content].gsub("\n", "<br/>\n"))
      c.add_element("wp:comment_approved").text = "1"
      c.add_element("wp:comment_parent").text = "0"

      num = num + 1
      item.add_element(c)
    }

    doc.elements["//channel"].add(item)
  }

  doc.write $stdout, 0
end


if ARGV.length < 2
  abort "USAGE: ruby #{$0} [mt file] [timezone (ex) +9]"
end

mt_path = ARGV[0]
timezone = ARGV[1].to_i
posts_dir = ARGV[2] if ARGV.length == 3

main(mt_path, timezone, posts_dir)
