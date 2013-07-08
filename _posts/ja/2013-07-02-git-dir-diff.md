---
layout: post
title: git difftool --dir-diff が便利すぎて泣きそうです
tags: Git
lang: ja
thumbnail: http://farm4.staticflickr.com/3792/9191502091_5f4e156b87_o.jpg
seealso:
- ja/2013-07-09-symlink-dir-diff-on-windows
- ja/2013-01-11-github-clone-http
- ja/2012-04-12-msysgit-utf8-2
- ja/2013-03-29-git-new-workdir
- ja/2013-05-02-git-commit-amend
- ja/2013-04-05-sourcetree
---
{% image http://farm3.staticflickr.com/2869/9194395890_e02e5eae04_o.jpg, 550, 244 %}

Git の 1.7.11 から `git difftool` コマンドに `--dir-diff` というオプションが追加されたのですが、これがライフ チェンジングだと思ったので紹介します。

`--dir-diff` 登場以前の `git difftool` は「ファイルごとに順番に差分を表示していく」ことしかできず、使い勝手はいまいちでした。それが、`--dir-diff` オプションの登場で状況が一変したわけです。


こんな感じの使い心地だよ
========================

ある Git レポジトリーで `dir1/a.txt` と `dir2/c.txt` を編集したとしましょう。

この状態で `git difftool --dir-diff` または `git difftool -d`  を実行してみると・・・。

{% image http://farm6.staticflickr.com/5339/9190948901_e8af0e9b5d.jpg, 850, 622 %}

はい、差分のあるファイルが一覧で表示されました。

(difftool に WinMerge を設定して、メニューから [ツリー表示] を有効にしたときの表示例です。設定方法は後述します)


個別のファイルの diff を見る
----------------------------

`a.txt` を選択すると、新しいタブが開いて、`a.txt` の差分が表示されます。

{% image http://farm6.staticflickr.com/5477/9193747196_ebd8033182.jpg, 850, 622 %}

カラフルに色分けされているし、ショートカットキーで前後の差分に移動できるので便利です (WinMerge の場合は Alt + ↑ と Alt + ↓)。

当然、タブを移動して差分一覧に戻れば、`c.txt` の差分も表示できます。

コマンドラインの `git diff` に比べて、

* 確認するファイルを選びやすい
* 差分間の移動がキーボードでやりやすい
* ファイル全体が表示されているので、差分から前後に好きなだけたどっていける

といったところが嬉しいですね。

おっと、ここまでなら、GUI な Git クライアントでも同じようなことはできますね。便利なのはこの次です。


ファイル編集も！
----------------

なんと、右側のファイルを編集して保存すると、**ワーキング ディレクトリーに反映される**のです (ただし、右側のファイルがワーキング ディレクトリーのファイルと同じ内容のときのみ)。

これがとてつもなく便利です。

差分を見ながら、「この差分は不要」とか「typo 発見」とか気づいたときに、その場で修正ができちゃうわけです。


比較対象は無限大
----------------

`git difftool` で比較対象を指定する方法は `git diff` とまったく同じです。

たとえば、`git difftool -d master...topic` として、トピックブランチでの変更点をまとめて閲覧したりもできるわけです。`git difftool -d --cached` としてインデックスとの差分を確認できるわけです。任意のコミット間の差分も確認できるわけです。タグがうってあれば、特定のバージョン間の差分も確認できるわけです

うれしいですね。


裏側で起こっていること
======================

`git difftool -d` を実行したときに、裏側で何が起こっているのでしょうか。

内部的に `git diff` を呼び出して、出てきたファイルを一時ディレクトリーにチェックアウトしています。

たとえば、先ほどの例でいうと

```
Temp/git-difftool.VoxJJ/
    left/
        dir1/
            a.txt
        dir2/
            c.txt
    right/
        dir1/
            a.txt
        dir2/
            c.txt
```

といった構造になります。中身が同一なファイルはチェックアウトされないので、大きなレポジトリーでも安心です。

さらに、Mac や Linux では、`right` のファイルがワーキング ディレクトリーと同じなら、「ワーキング ディレクトリーへのシンボリックリンク」になっています。その結果、`right` のファイルを書き換えると、即時にワーキング ディレクトリーに反映されるわけです。

Windows の場合は、difftool を終了したときに、ワーキング ディレクトリーに一時ファイルを書き戻す動作になっています。ちょっと不便なので、シンボリックリンクを使うように改造したいところです。(追記) 改造しました!! {% post_link ja/2013-07-09-symlink-dir-diff-on-windows %}


使えるようにするまでの準備
==========================

便利なのは分かってもらえたと思うので、使えるように準備してみましょう！


最新の git-difftool を取得しておく
----------------------------------

先ほど書いた通り、`git difftool --dir-diff` は 1.7.11 から追加されています。ただ、最近になっていくつか大きなバグが修正されているので、なるべく新しいヤツ (Linux なら 1.8.3、Windows なら 1.8.3.2 ) を利用するのがオススメです。

Git 全体を更新するのが面倒な場合は、git-difftool だけを

* [GitHub (git/git-difftool.perl at master)](https://github.com/git/git/blob/master/git-difftool.perl)

から落としてきて、`libexec/git-core/git-difftool` に上書きすれば、よほど古いバージョンじゃなければ動く・・・と思います。


difftool の設定: WinMerge 篇
----------------------------

Windows で WinMerge を使う場合は、`.gitconfig` に次のように書きます (Git for Windows の場合)。

```ini
[diff]
    tool = winmerge
[difftool winmerge]
    path = C:/Program Files (x86)/WinMerge/winmergeu.exe
    cmd = \"C:/Program Files (x86)/WinMerge/winmergeu.exe\" -r -u \"$LOCAL\" \"$REMOTE\"
```

インストール先が異なる場合は適宜修正してください。

コマンドライン オプションの意味は次の通りです。

* `-r`: 再帰的に比較する
* `-u`: 最近開いた一覧に追加しない

人によっては `-e` を追加して ESC で WinMerge を閉じられるようにしているようですが、複数タブを開いてるときに ESC を押して WinMerge が閉じてしまうと困るので私は設定していません。


difftool の設定: meld 篇
------------------------

Mac や Linux で meld を利用する場合は、`.gitconfig` に次のように書きます。

```ini
[diff]
    tool = meld
```

簡単ですね。

Git 本体に meld のコマンドラインオプションの情報が入ってるので、これで動くようです。

(手元に Mac がないので動作確認はできませんでしたが、[git - View differences of branches with meld? - Stack Overflow](http://stackoverflow.com/questions/2006032/view-differences-of-branches-with-meld#answer-12815806) に同じ手順が書いてあって、プラス評価がついてるので正しいはずです)

Pro Git には [P4Merge を使う手順](http://git-scm.com/book/ja/Git-%E3%81%AE%E3%82%AB%E3%82%B9%E3%82%BF%E3%83%9E%E3%82%A4%E3%82%BA-Git-%E3%81%AE%E8%A8%AD%E5%AE%9A#外部のマージツールおよび-Diff-ツール) が書いてあるんだけど、P4Merge はディレクトリーの比較に対応してないので、`--dir-diff` には活用できません。


エイリアスを設定する
--------------------

このあたりは好みですが、`.gitconfig` でエイリアスを設定しておくと便利でしょう。

```ini
[alias]
    d = difftool -d
    dc = difftool -d --cached
    dp = difftool -d HEAD~
```

`git d <branch>` とか `git d HEAD` のように入力するだけで、difftool が `--dir-diff` で立ち上がるようになります。


まとめ
======

`difftool --dir-diff` で快適な Git 生活を！
