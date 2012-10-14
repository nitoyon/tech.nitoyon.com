# -*- encoding: utf-8 -*-

# Update JS and CSS url
# =====================
#
# This script modifies JavaScript and CSS URL in all HTML files.
#
# USAGE: update_js_css_url.rb [-d] site_dir [target_dir]
# 
# (example)
#     $ ruby update_js_css_url.rb path/to/site/dir
#     <script src="/foo/bar.js"> вк <script src="/foo/bar.js?1234567890">
#     <link href="/foo/baz.css"> вк <link href="/foo/baz.css?1234567890">
#
#     $ ruby update_js_css_url.rb -d path/to/site/dir
#     <script src="/foo/bar.js?1234567890"> вк <script src="/foo/bar.js">
#     <link href="/foo/baz.css?1234567890"> вк <link href="/foo/baz.css">
#
#     $ ruby update_js_css_url.rb path/to/site/dir path/to/site/dir/tmp
#
# Added value (`1234567890`) means timestamp of the file.

def main(site_dir, target_dir, delete_time)
  # Open file
  puts target_dir
  Dir::glob("#{target_dir}/**/*.html").each { |f|
    update_timestamp(site_dir, f, delete_time)
  }
end

def update_timestamp(dir, file, delete_time)
  s = ""
  count = 0
  puts "parsing #{file}..."

  open(file) { |f| s = f.read }
  s2 = s.gsub(%r!<((?:link|script)[^>]+(?:src|href))="(/[^/][^"]+\.(?:js|css))(?:\?\d+)?"!) { |m|
    count += 1
    if delete_time
      %(<#{$1}="#{$2}")
    else
      time = File::mtime(dir + $2).to_i
      %(<#{$1}="#{$2}?#{time}")
    end
  }

  if s != s2
    open(file, 'w') { |f| f.write(s2) }
    puts "wrote #{file} (replaced #{count})"
  else
    puts "skipped #{file}"
  end
end


if ARGV.length < 1
  abort "USAGE: ruby #{$0} [-d] site_dir [target_dir]"
end

delete_time = false
if ARGV[0] == "-d"
  delete_time = true
  ARGV.shift
end

site_dir = target_dir = ARGV[0]
if ARGV.length > 1
  target_dir = ARGV[1]
end

main(site_dir, target_dir, delete_time)
