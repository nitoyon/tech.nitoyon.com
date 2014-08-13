---
layout: post
title: 大旦那のお気に入りの裏側
lang: ja
date: 2006-11-08 00:24:21 +0900
---
<a href="./">大旦那のお気に入り</a>の技術的な側面に関して解説してみました。


大旦那のお気に入りデータの取得
==============================

まずは大旦那のお気に入りを調べるところから始めました。はてな ID からお気に入りを取得する部分は Perl の `HTML::TreeBuilder::XPath` を使って書いてみました。

```perl
sub getFavorites{
	my $id = shift;
	my $res = URI::Fetch->fetch(sprintf 'http://b.hatena.ne.jp/%s/favorite', $id)
	 or die URI::Fetch->errstr;

	my $tree = HTML::TreeBuilder::XPath->new;
	$tree->parse($res->content);
	$tree->eof;

	# /user1//user2//user3/
	my $favorites = $tree->findvalue('/html//div[@class="favoritelist"]//li/a[position()=1]/@href');
	$favorites=~m!/([^/]+)/!g;
}
```


JSON 化
=======

このデータを JavaScript で食えるように JSON 化してやったのが `data.js` です。

```javascript
var fav = {
	jkondo : {count : 690, favorite : ["naoya","umedamochio","mkusunok","miyagawa"]},
	// ...
};
```

旦那衆、若旦那の被お気に入り数のデータと合わせても 61KB。この程度なら、ページをロードするたびに読み込んでも問題ない、と判断して毎回クライアントに渡すことにしました。

その結果、集計結果を切り替えても、アイコンをクリックして詳細を見ても、すべてブラウザ内で処理が可能になりました。サーバーにリクエストをする必要がなく、HTTP リクエストのラウンドトリップタイムがない分だけ、すばやくページ表示することができます。

ただ、この方法は万能ではなくて、すべてクライアントで処理する必要があるため、必要なデータだけをサーバーからとってくる Ajax に比べて、メモリや CPU の消費量が増えてしまうという問題もあります。作成するシステムに応じて、どれだけをサーバーに任せて、どれだけをクライアントに任せるかを判断する必要があります。


条件の追加
==========

今回、すべてのデータをクライアントに転送していることを利用して、１つ面白いことができます。集計条件の追加です。

<a href="alphavorite20061112.lzh">ソース一式</a>をダウンロードして、alphavorite.js をエディタで開いてみてください。先頭で analyzers というハッシュがあるのですが、ここで集計方法を定義しています。

```javascript
var analyzers = {
    count : {
        name : "各1pt",
        point : function(){return 1;},
        pixelPerRatio : 16
    },

    fav : {
        name : "被Fav数",
        point : function(hifav, fav, fromid, toid){return hifav},
        pixelPerRatio : 0.16
    },

    fav_ratio : {
        name : "被Fav数 / Fav数",
        point : function(hifav, fav, fromid, toid){return fav != 0 ? hifav / fav : 0},
        pixelPerRatio : 1.6
    }
};
```

この部分を修正することで、新たに集計方法を追加することができます。

例えば、id が３文字の人でランキングをとるには次のようにします。

```javascript
    },
    num : {
        name : "3文字IDのみ",
        point : function(hifav, fav, fromid, toid){
            return toid.length == 3 ? 1 : 0;
        },
        pixelPerRatio : 16
    }
};
```

<img src="cap4.gif" width="239" height="310" alt="3文字ID">

index.html をブラウザで開くだけで、3文字IDの集計をテストすることができます。データをすべて JavaScript が持っているおかげで、ローカル環境でも簡単にテストできるわけです。これこそ、*サーバーレス*と表現したおもしろさです。

他にも、例えば、id に数字を含む、とか、はてなの社員だけ、とか、いろいろやって遊べるかもしれません。

いちおうパラメータを解説。

* <b>name</b>: 画面に表示する日本語名。
* <b>point</b>: 大旦那が何点投票するかを示す値。
* <b>hifav</b>: 大旦那の被Fav数。
* <b>fav</b>: 大旦那のFav数。
* <b>fromid</b>: 大旦那の id。
* <b>toid</b>: 投票対象の id。
* <b>pixelPerRatio</b>: １ポイントを何ピクセルで表示するか。画面幅に合わせて適当に変更すべし。


おまけ
======

蛇足を２つほど。

最近のブックマークを取得する部分は、Drk7jp さんの <a href="http://www.drk7.jp/MT/archives/001011.html">XML を JSON に変換するサービス</a> を利用しています。

もう１つの蛇足。擬似フレームっぽいデザインですが、JavaScript は使っていません。すべて CSS だけでデザインしました。CSS は <a href="http://jigen.aruko.net/">jigelog</a> さんのものを参考にさせてもらいながら作り上げました。
