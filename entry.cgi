#!/usr/local/bin/ruby

# Redirector
# ==========
#
# /entry/20090909/text_mask => /ja/blog/2009/09/09/text-mask/
#
# Assumption
# ----------
#
# * URL 'entry/a/b' is redirected to 'entry.cgi/a/b'
# * ruby is installed at /usr/local/bin/ruby

require 'cgi'

# get path from PATH_INFO
path = ENV['PATH_INFO'] || '/'

if path =~ %r|^/(\d{4})(\d{2})(\d{2})/([^/]+)|
  redirect_to = "/ja/blog/#{$1}/#{$2}/#{$3}/#{$4.gsub('_', '-')}/"
elsif path =~ %r|/archive|
  redirect_to = '/ja/blog/archive/'
else
  redirect_to = '/ja/blog/'
end


print CGI.new.header({
  'status' => '301 Moved Permanently',
  'Location' => redirect_to
})
