# -*- encoding: utf-8 -*-

# reference:
#     http://developer.hatena.ne.jp/ja/documents/diary/apis/atom

# URL domain
$new_url = "http://tech.nitoyon.com/ja/blog/"



require 'rubygems'
require 'atomutil'
require 'cgi'

$hatena_id = 'nitoyon'
$blog_id = 'nitoyon'

module Atompub
  class HatenaClient < Client
    def publish_entry(uri)
      @hatena_publish = true
      update_resource(uri, ' ', Atom::MediaType::ENTRY.to_s)
    ensure
      @hatena_publish = false
    end

    private
    def set_common_info(req)
      req['X-Hatena-Publish'] = 1 if @hatena_publish
      super(req)
    end
  end
end

def post_redirect(auth, entry)
  client = Atompub::HatenaClient.new :auth => auth
  service = client.get_service 'http://d.hatena.ne.jp/%s/atom' % $blog_id

  collection_uri = 'http://d.hatena.ne.jp/%s/atom/blog' % $blog_id

  entry_url = collection_uri + "/" + entry[:date].strftime('%Y%m%d') + "/" + entry[:name].gsub('-', '_')
  new_url = "http://tech.nitoyon.com/ja/blog/" + 
    entry[:date].strftime('%Y/%m/%d') + "/" + entry[:name] + "/"

  puts "get    #{entry_url} -> #{new_url}"
  e = client.get_entry(entry_url)
  puts "update #{entry_url} -> #{new_url}"

  content = %(#{new_url} に移転しました。\n====\n><script src="http://www.gmodules.com/ig/ifr?url=http://tech.nitoyon.com/misc/redirector.xml&amp;up_url=#{CGI.escape(new_url)}&amp;synd=open&amp;w=320&amp;h=50&amp;title=redirector&amp;border=%23ffffff%7C3px%2C1px+solid+%23999999&amp;output=js"></script><)
  e.content = content

  client.update_entry entry_url, e
end

def get_posts(dir)
  entries = []
  Dir.glob(dir).each { |file|
    next if Dir.exists? file

    abort "invalid format #{file}" unless file =~ /(\d{4})-(\d{2})-(\d{2})-(.*)(\.[^.]+)$/
    y, m, d, name = $1, $2, $3, $4

    content = File.read(file)
    abort "title not found #{file}" unless content =~ /title: (.*)/
    title = $1

    entries << {
      :date => Time.new(y.to_i, m.to_i, d.to_i),
      :name => name,
      :title => title,
    }
  }
  entries
end

password = STDIN.gets.strip
auth = Atompub::Auth::Wsse.new :username => $hatena_id, :password => password

entries = get_posts('_posts/ja/*')
entries.each { |e|
  #next if e[:date] < Time.new(2007, 1, 24)
  post_redirect(auth, e)
}
