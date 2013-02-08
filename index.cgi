#!/usr/local/bin/ruby

# Redirect '/' to '/en/' or '/ja/' based on Accept-Language

require 'cgi'

def get_accept_languages
  # see RFC 2616
  # (ex) ja,en-US;q=0.8,en;q=0.6
  accept_langs = (CGI.new.accept_language || '').split(/,\s*/)

  # { 'ja' => 1, 'en-US' => 0.8, ...}
  lang_pri = accept_langs.inject({}) { |hash, lang|
    if lang =~ /^([a-z-]+);q=([\d\.]+)$/i
      hash[$1] = $2.to_f
    else
      hash[lang] = 1.0
    end
    hash
  }

  # descending sort by qvalue
  lang_pri.keys.sort { |a,b|
    lang_pri[b] <=> lang_pri[a]
  }
end

def is_ja(langs)
  langs.each { |lang|
    if lang =~ /^ja(-JP)?$/i
      return true
    elsif lang =~ /^en(-.*)?$/
      return false
    end
  }
  return false
end


cgi = CGI.new
langs = get_accept_languages
is_ja = is_ja(langs)
url = is_ja ? '/ja/' : '/en/'
url += "about/" if cgi.query_string == "about"

print cgi.header({
  'status' => '302 Found',
  'Location' => url,
})
