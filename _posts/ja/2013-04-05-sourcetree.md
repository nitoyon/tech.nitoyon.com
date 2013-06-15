---
layout: post
title: SourceTree が Git のグローバルな無視リストを書き換えて困った話
tags: Git
lang: ja
thumbnail: http://farm9.staticflickr.com/8382/8619841968_7bd4237420_o.png
seealso:
  - 2013-03-29-git-new-workdir
  - 2013-01-11-github-clone-http
  - 2012-04-12-msysgit-utf8-2
  - 2012-02-21-msysgit-utf8
  - 2012-12-21-text-hatena-js-github
---
Git で `git status` を実行したときに、Untracked files として表示されるはずのファイルが表示されない現象に出会った。

いろいろ調べてみたところ、SourceTree さんがインストール時にグローバルな無視リストを作成していたことが判明した。SourceTree を使ってないときにも影響がでるのでたちが悪い。


勝手に書き換えられてしまうファイルはこれだ!!
============================================

Windows 版の例だけど、まず、`.gitconfig` に次のような設定が追加されちゃう。

```ini
[core]
    excludesfile = C:\\Users\\username\\Documents\\gitignore_global.txt
```

Mac の場合は `/User/username/.gitignore_global` に設定する模様。

gitignore_global.txt はこんな感じになってた。

```
#ignore thumbnails created by windows
Thumbs.db
#Ignore files build by Visual Studio
*.obj
*.exe
*.pdb
*.user
*.aps
*.pch
*.vspscc
*_i.c
*_p.c
*.ncb
*.suo
*.tlb
*.tlh
*.bak
*.cache
*.ilk
*.log
*.dll
*.lib
*.sbr
```

この辺の拡張子は、Windows 関係の開発で自動生成されたり、中間ファイルだったりするファイルなので、確かにコミットする必要がないことはない。


.gitconfig に excludesfile がないときに発動
===========================================

セットアップ時に、最初のダイアログには [Allow SourceTree to modify global Git and Mercurial config files] という設定項目がある。

{% image http://farm9.staticflickr.com/8382/8619841968_d036e18115.jpg, 588, 625 %}

デフォルトでチェック入ってるんだけど、これが入ってる以上は、`.gitconfig` がいじられても文句は言えない。

デフォルトのままで先に進むと、`.gitconfig` に `excludesfile` の設定がない場合には SourceTree さんは上に書いたような書き換えを行ってくれる。

シンセツダナー。

この親切すぎて涙がでてしまう挙動は、当然のように一部のユーザーの逆鱗に触れることとなり、非難轟々、雨嵐霰がふき乱れた。

{% tweet 314672749203308544 %}

「最低なやつめ！　なんで gitignore_global.txt を勝手に作って .dll と .exe を除外しちゃうんだよ！？」というユーザーのお怒りの声。

これに対して、「怒らせてごめんよ。すでにグローバルな ignore ファイルがあればそんなことはしないよ。」と答える SourceTree さん。

{% tweet 314672902148616192 %}

「git に不慣れな人を助けるために、グローバルな ignore ファイルがないならそうしてるんだよ。だって、exe や dll をコミットすることなんてめったにないでしょ？」。まぁ、それはそうなんだけども・・・。

{% tweet 314674613844062208 %}

「次のリリースでは、もうちょっと注意を引きやすい警告を出すようにして、バイナリー ファイルをコミットしたい人を困らせないようにするよ」と、将来のバージョン アップを誓っている。


最近は警告ダイアログをだしてくれる
==================================

で、その結果、最近のリリースでは、こんなダイアログが表示されるようになった。

{% image http://farm9.staticflickr.com/8391/8619841994_5093182205_o.png, 623, 344 %}

ざっと訳すと

> グローバルな ignore ファイルがないようだけど、SourceTree がデフォルトのやつを設定したげようか？
>
> .exe とか .dll とか .obj とか .suo とか Debug のようなフォルダーとか、普通はソース管理しないようなやつを追加しといてあげるよ。
>
> もし、デフォルトで全部のファイルをみれるようにしたいなら、とりあえず No を選んどいてね。あとで、Tools > Options から設定することもできるよ。

と書いてある。

次のキャプチャーを見る限りは Mac 版でも「グローバル無視リスト」を書き換える処理はあるようだ。

{% image http://farm9.staticflickr.com/8525/8618737121_b83669bf6a.jpg, 652, 595 %}

(画像は [kashew_nuts-tech: Mac用Git/MercurialのGUIクライアント-SourceTree-を試してみた](http://kashewnuts-tech.blogspot.jp/2011/11/macgitmercurialgui-sourcetree.html) より)


まとめ
======

SourceTree の Windows 版を試した人 (特に初期のバージョン) は、マイドキュメント直下に `gitignore_global.txt` がないか確認しておくとよいだろう。このファイルが残っていると、Git を使っていて無駄に混乱してしまうかもしれない。分かってて設定する分にはいいんだけども。
