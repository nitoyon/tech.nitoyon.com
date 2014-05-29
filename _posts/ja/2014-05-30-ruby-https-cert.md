---
layout: post
title: Ruby で HTTPS 接続するときの証明書で悩んだ話
tags: Ruby
lang: ja
seealso:
- ja/2014-03-14-utf8-str-count
- ja/2013-12-09-setctime
- ja/2012-11-06-flickr-auto-update
- ja/2012-10-29-liquid-drop
- ja/2008-12-02-ubygems
- ja/2008-11-09-utf8-normalize
---
flickr の API が HTTPS のみになるというので、{% post_link 2012-11-06-flickr-auto-update, 以前作ったスクリプト %}に手を入れようとしたら無駄に手こずったので、ググって得た知見をメモしておく。


Ruby 1.8 系で証明書を検証しない問題
===================================

上記のスクリプトは、さくらのレンタルサーバーにて Ruby で動かしている。

2014 年にどうかという話だけど、Ruby のバージョンは 1.8.7 である・・・。

Net::HTTP で https に接続したら

> warning: peer certificate won't be verified in this SSL session

という警告が出てきて困ったので調べてみた。

つかったコードはこんなやつ。

```ruby
require 'net/https'
https = Net::HTTP.new('www.google.com', 443)
https.use_ssl = true
https.start { |h|
}
```

警告が出る理由
--------------

Ruby 1.8 の時点では上記のようなコードで HTTPS 接続したときには、デフォルトでは証明書を検証しないポリシーになっていた。

```ruby
    unless @ssl_context.verify_mode
      warn "warning: peer certificate won't be verified in this SSL session"
      @ssl_context.verify_mode = OpenSSL::SSL::VERIFY_NONE
    end
```

(https://github.com/ruby/ruby/blob/v1_8_7/lib/net/http.rb#L563-566 より)

デフォルトで証明書検証しないというのは罠なので、そのことを教えようとしている warning のようだ。


警告を消す方法
--------------

上のコードをみたら分かる通り、明示的にポリシーを指定すれば警告は消える。

  * 証明書を検証したい場合: `https.verify_mode = OpenSSL::SSL::VERIFY_PEER` を追加する
  * 証明書を検証したくない場合: `https.verify_mode = OpenSSL::SSL::VERIFY_NONE` を追加する


1.9 系で変わってる
------------------

ちなみに、「デフォルトでは証明書を検証しない」という挙動は、1.9 系では[修正されている](https://github.com/ruby/ruby/commit/c6920177f3e561f779f54534e511f0c9f0de6edd)。


ルート証明書どうするの問題
==========================

証明書を検証する設定にしたら、「証明書の検証に失敗したぜ」というような例外がでるようになった。

> OpenSSL::SSL::SSLError: SSL_connect returned=1 errno=0 state=SSLv3 read server certificate B: certificate verify failed

これはどうも、自分の環境にルート証明書が正しく入ってないっぽい。

いかんせんレンタルサーバーなので、何ともできない。仕方がないので、どこかからルート証明書を取ってくることにした。

ググると http://curl.haxx.se/docs/caextract.html が有名っぽい。cURL の人が mozilla.org のデータを PEM 形式に変換してくれているヤツ。

ここにある cacert.pem を拾ってきて、`ca_file` に cacert.pem のパスを指定すればおしまい。

```ruby
require 'net/https'
https = Net::HTTP.new('www.google.com', 443)
https.use_ssl = true
https.verify_mode = OpenSSL::SSL::VERIFY_PEER
https.ca_file = '/path/to/cacert.pem'
https.start { |h|
}
```

まとめ
======

新しい OS を新規セットアップした場合はたぶんまったく問題にならないであろうことに苦しめられつつ、以上の無駄な知見を得た。

flickr の更新用に使っていた flickraw というライブラリーは `verify_mode` や `ca_file` を指定するオプションがなかったので、[「追加してね」という pull request](https://github.com/hanklords/flickraw/pull/75) を投げたらマージしてもらえた。めでたし。

あと、[Ruby 「warning: peer certificate won&#8217;t be verified in this SSL session」 | HAPPY*TRAP](http://www.happytrap.jp/blogs/2010/02/23/2919/) が非常に役に立った。ありがたや。
