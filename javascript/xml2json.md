---
layout: post
title:  xml2json.cgi - ドメインを超えてXMLを読みこむ
lang: ja
date: 2006-01-13 00:05:49 +0900
---
Ajax の弱点は別ドメインのページを取得できないこと。そんな制限を取っ払って、別ドメインの XML を取得できる CGI を作ってみました。


使い方
======

XMLファイルの例:

```xml
<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<items>
  <item>
    <jcity>千代田区</jcity>
    <jlocal>千代田</jlocal>
    <jpref>東京都</jpref>
    <pref_cd>13</pref_cd>
    <zip_cd>1000001</zip_cd>
  </item>
</items>
```

XMLファイルへのアクセス方法１（同期）
------------------------------------

XML の URL は http://www.example.com/sample.xml だと仮定します。XML を読み込むには次のようなタグを HTML に記述します。

```html
<script charset="utf-8" type="text/javascript" src="xml2json.cgi?url=http%3A%2F%2Fwww.example.com%2Fsample.xml"></script>
```

xml2json.cgi は自分のサーバーに設置します。

上記の JavaScript は次のように展開されてインポートされます。

```javascript
if (typeof(xml) == 'undefined') xml = {};
xml.data = {
  items: {
    item: {
      jcity: "千代田区",
      jlocal: "千代田",
      jpref: "東京都",
      pref_cd: "13",
      zip_cd: "1000001"
    }
  }
}

if (typeof(xml.onload) == 'function') xml.onload(xml.data);
```

たとえば、HTML からは次のようにして XML の情報を利用します。

```html
<script charset="utf-8" type="text/javascript" src="xml2json.cgi?url=http%3A%2F%2Fwww.example.com%2Fsample.xml"></script>
<script>
alert(xml.data["items"]["item"]["jcity"];
</script>
```

XMLファイルへのアクセス方法２（非同期）
--------------------------------------

script タグでインポートしてしまうと、スクリプトのダウンロードが完了するまで、script タグ以降の HTML の表示がとまってしまいます。

そこで、非同期に xml2json を呼び出す方法を示します。ここでは、`window.onload` イベントで読み込みを行っています。

```javascript
window.onload = function(){
	var s = document.getElementsByTagName("head")[0].appendChild(document.createElement("script"));
	s.type = "text/javascript";
	s.charset = "utf-8";
	s.src = "xml2json.cgi?url=http%3A%2F%2Fwww.example.com%2Fsample.xml";
}

var xml = {};
xml.onload = function(data){
	// 読み込み後の処理
}
```


XML2JSON のソースコード
=======================

分かりやすくするために、複雑なエラー処理がない単純なソースコードを示します。サーバー側で CGI として動作します。

`LWP::UserAgent` でダウンロードして `XML::Simple` で XML 解析して、`Data::Dumper` でダンプしています。Perl の Dump と JavaScript の JSON 形式が酷似しているため、処理はこれだけです（ダンプデータの `=>` を `:` に置換するだけ・・・）。

```perl
#!/usr/local/bin/perl

use CGI;
use LWP::UserAgent;
use XML::Simple;
use Data::Dumper;

my $q = new CGI;

# param
my $var = $q->param('var');
$var = "xml" if !defined $var or $var!~/^[a-zA-Z_]+$/;
my $url = $q->param('url');
die if !defined $url or $url!~m!^http://!;

# request
my $ua = LWP::UserAgent->new;
$ua->agent("XML2JSON/0.1 ");
my $req = HTTP::Request->new(GET => $url);
my $res = $ua->request($req);
die if !$res->is_success;
die if $res->headers->header("Content-Type")!~m!/xml!;

# XML Dump
$XML::Simple::PREFERRED_PARSER = 'XML::Parser';
my $xmlobj = XMLin($res->content);
$Data::Dumper::Indent = 1;
$Data::Dumper::Useqq = "utf8";
$json = Dumper($xmlobj);

$json=~s/^\$VAR1/$var.data/;
$json=~s/([^\\])" => ("|{|\[)/$1" : $2/g;

# output
print $q->header(-type => "text/plain", -charset => "utf-8");
print "if (typeof($var) == 'undefined') $var = {};\n";
print $json."\n";
print "if (typeof($var.onload) == 'function') $var.onload($var.data);";
```

毎回サーバーに取りに行くのは負荷が高いので、こんな風にキャッシュ機能をつけるとよいかもしれません。

```perl
#!/usr/local/bin/perl

use CGI;
use Jcode;
use LWP::UserAgent;
use XML::Simple;
use Digest::MD5 qw(md5_hex);
use Data::Dumper;

my $cache_dir = "../cache/";
my $cache_lifetime = 600; # 10min

my $q = new CGI;

# param
my $var = $q->param('var');
$var = "xml" if !defined $var or $var!~/^[a-zA-Z_]+$/;
my $url = $q->param('url');
&error("url is not set") if !defined $url or $url!~m!^http://!;

my $json;
my $cache = $cache_dir.md5_hex($url);
if(-f $cache && (stat($cache))[9] + $cache_lifetime > time){
	open(CACHE, $cache);
	$json = join("", <CACHE>);
	close(CACHE);
}
else{
	# request
	my $ua = LWP::UserAgent->new;
	$ua->agent("XML2JSON/0.1 ");
	my $req = HTTP::Request->new(GET => $url);
	my $res = $ua->request($req);
	&error("cannot get url") if !$res->is_success;
	&error("cotnent is not xml (".$res->headers->header("Content-Type").")") if $res->headers->header("Content-Type")!~m!/xml!;

	# XML Dump
	$XML::Simple::PREFERRED_PARSER = 'XML::Parser';
	my $xmlobj = XMLin($res->content);
	$Data::Dumper::Indent = 1;
	$Data::Dumper::Useqq = "utf8";
	$json = Dumper($xmlobj);

	# Write cache
	my $cache = $cache_dir.md5_hex($url);
	if(open(CACHE, ">$cache")){
		print CACHE $json;
		close(CACHE);
	}
}
$json=~s/^\$VAR1/$var.data/;
$json=~s/([^\\])" => ("|{|\[)/$1" : $2/g;

# output
print $q->header(-type => "text/plain", -charset => "utf-8");
print "if (typeof($var) == 'undefined') $var = {};\n";
print $json."\n";
print "if (typeof($var.onload) == 'function') $var.onload($var.data);";

sub error{
	print $q->header(-type => "text/plain", -charset => "utf-8");
	print "var $var = \"$_[0]\";";
	exit;
}
```

思うこと
========

開発者的には RSS を XML で吐き出すのと同時に JSON で吐き出してくれるページが増えてくれたらうれしいなぁ。

ただ、悪意のある JavaScript をインポートしてしまうと、訪問者の Cookie が漏れてしまうので、Cookie で個人情報を管理している場合は注意が必要です。信頼できる会社に XML2JSON なサービスをやってほしいところです。

(追記) Yahoo! Pipes を使えば、外部サイトの内容を JSONP で取得できるようになりました。詳しくは {% post_link 2007-12-12-pipes-page-fetch %} を見てください。
