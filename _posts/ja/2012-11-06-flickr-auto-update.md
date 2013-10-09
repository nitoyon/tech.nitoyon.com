---
layout: post
title: Flickr の Set 内の写真一覧を更新する Ruby スクリプトを作った
tags: Ruby
lang: ja
---
身内向けの写真ブログを Flickr を使ってやってます。

非公開で写真をアップロードして、Set の Guest Pass 機能と組み合わせて、URL を知ってる人だけが Set の写真を見られる、という形で運営してます。

さて、Set に写真を追加していけば更新できるわけですが、毎回 Flickr を開いて作業するのが面倒になってきました。Set 内の写真が増えてくると、UI がもっさりしてくるのも嫌でした。

となれば、Flickr の API を使って、スクリプトで自動処理したくなるのがプログラマ心情でございます。


さっそく作った
==============

ということで、Flickr の API とにらめっこしながら作ってみました。

```ruby
require 'flickraw'
require 'date'
require 'set'

# load conf and set API key and access token
# (ex)
# { "api_key": "xxxxxxx",
#  "shared_secret": "xxxxx",
#  "access_token": "xxxxxxx",
#  "access_secret": "xxxxxx"
# }
conf = nil
open('flickr.conf') { |f|
  conf = JSON.load(f)
}

FlickRaw.api_key = conf['api_key']
FlickRaw.shared_secret = conf['shared_secret']
flickr.access_token = conf['access_token']
flickr.access_secret = conf['access_secret']


def get_set_id_by_name(set_name)
  res = flickr.photosets.getList
  for set in res
    if set.title == set_name
      return set.id
    end
  end
  nil
end

def get_photos_in_a_set(photoset_id)
  page = 1
  pages = 1
  photo_ids = []
  while page <= pages
    res = flickr.photosets.getPhotos :photoset_id => photoset_id.to_s,
                                     :page => page.to_s
    photo_ids.concat res.photo.map { |photo| photo.id }

    page = res.page.to_i + 1
    pages = res.pages.to_i
  end
  { :id => res.id,
    :primary => res.primary, 
    :photo => photo_ids }
end

def log(str)
  puts "#{Time.now} #{str}"
end


def main(cur_set_id)
  # get set 'YYYY-MM-DD'
  new_set_name = Date::today.to_s
  new_set_id = get_set_id_by_name(new_set_name)
  if new_set_id.nil?
    log("set #{new_set_name} not found")
    exit
  end
  log("set #{new_set_name} found: #{new_set_id}")

  # Get set information
  cur_set = get_photos_in_a_set(cur_set_id)
  new_set = get_photos_in_a_set(new_set_id)
  log("current set has #{cur_set[:photo].length} photos")
  if new_set[:photo].length == 0
    log("no photo")
    exit
  end
  log("add #{new_set[:photo].length} photo(s) to it")

  # Create new photo_ids
  cur_photos_set = Set.new(cur_set[:photo])
  photos = cur_set[:photo].dup
  log("current photos: #{photos.join(',')}")
  modified = false
  for photo in new_set[:photo]
    if cur_photos_set.include? photo
      log("skip photo #{photo}")
    else
      log("add photo #{photo}")
      photos.unshift(photo) 
      modified = true
    end
  end
  log("new photos: #{photos.join(',')}")

  if modified
    log("editPhotos start")
    res = flickr.photosets.editPhotos :photoset_id => cur_set[:id],
                                      :primary_photo_id => cur_set[:primary],
                                      :photo_ids => photos.join(",")
    log("editPhotos finished")
  else
    log("editPhots skipped")
  end

  # delete set
  log("delete photoset start")
  flickr.photosets.delete :photoset_id => new_set_id
  log("delete photoset finished")
end


if ARGV.length < 1
  log("set_id not specified")
  log("ruby flickr_update.rb [set_id]")
  exit
end

begin
  main(ARGV[0])
rescue SystemExit
rescue Exception => e
  log("exception #{e.inspect}\n#{e.backtrace.join("\n")}")
end
```


使い方
------

あらかじめ、写真をプライベートでアップロードしておきます。

たとえば、2012年11月06日に公開したい写真は、`2012-11-06` という Set に入れておきます。

その状態で、シェルから

```bash
$ ruby update_flickr.rb [set_id]
```

のように実行してやると、`2012-11-06` というセット内の写真を列挙して、コマンドライン引数で指定した `[set_id]` のセットの先頭に追加してくれます。作業が完了すれば `2012-11-06` というセットは消えます。

あとは、この処理を cron に突っ込んで、一日一回実行するようにしておけば自動化完了です。めでたし。


ライブラリは FlickRaw を利用
----------------------------

Flickr API を叩くためのライブラリは、[FlickRaw](https://github.com/hanklords/flickraw/) を使ってます。

`access_token` と `access_secret` は公式のドキュメントに書いてある通りにやれば取得できました。

そのあとは、Flickr の API のドキュメントを眺めながら書くだけでした。[Flickr Api Explorer](http://www.flickr.com/services/api/explore/flickr.photos.getRecent) を使えば、ブラウザー上で API の動作試験ができるのが楽でした。


Flickr への公開は Lightroom で
==============================

ちなみに、写真の現像から Flickr での公開までは、Lightroom を使ってます。

Lightroom にデフォルトでついてくる Flickr の公開サービス機能を使えば、Lightroom の上で Flickr にアップロードが完了します。

Lightroom の Tips としては、Flickr を [対象コレクション] に指定しておけば、[B] キーでアップロードするかどうかを選択できて楽です。

{% amazon jp:B007E921HU:detail %}


まとめ
======

自動化万歳、API を公開してるサービス万歳。
