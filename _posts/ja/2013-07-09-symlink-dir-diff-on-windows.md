---
layout: post
title: Windows でも git difftool --dir-diff でシンボリックリンクを使う方法
tags: Git
lang: ja
thumbnail: http://farm4.staticflickr.com/3792/9191502091_5f4e156b87_o.jpg
alternate:
  lang: en_US
  url: /en/blog/2013/07/09/symlink-dir-diff-on-windows/
seealso:
- ja/2013-07-02-git-dir-diff
- ja/2013-01-11-github-clone-http
- ja/2012-04-12-msysgit-utf8-2
- ja/2013-03-29-git-new-workdir
- ja/2013-05-02-git-commit-amend
---
`git difftool --dir-diff` が便利だよ、という話を {% post_link 2013-07-02-git-dir-diff %} で書きましたが、１つ宿題が残っていました。Windows では一時ファイルがワーキング ディレクトリーへのシンボリックリンクにならないので、Unix や Mac に比べて、少しだけ不便だよ、という話です。

そこで、Windows でもシンボリックリンクを使えるようにしちゃおう、というのがこのエントリーの趣旨でございます。


Windows 向けの応急処置パッチ
============================

Git for Windows 1.8.3 で動作確認しています。OS は Windows 7 (64 ビット)。

`C:\Program Files (x86)\Git\libexec\git-core\git-difftool` のパッチがこちら。

```diff
--- git-difftool	Sun Jun  2 11:28:06 2013
+++ git-difftool	Tue Jul  9 00:42:02 2013
@@ -283,7 +283,7 @@
 			exit_cleanup($tmpdir, 1);
 		}
 		if ($symlinks) {
-			symlink("$workdir/$file", "$rdir/$file") or
+			!system("git", "mklink", "$workdir/$file", "$rdir/$file") or
 			exit_cleanup($tmpdir, 1);
 		} else {
 			copy("$workdir/$file", "$rdir/$file") or
@@ -448,7 +448,7 @@
 	my $indices_loaded = 0;
 
 	for my $file (@worktree) {
-		next if $symlinks && -l "$b/$file";
+		next if $symlinks;
 		next if ! -f "$b/$file";
 
 		if (!$indices_loaded) {
```

適当な場所に保存して、GitBash を管理者権限で起動して適用してやります。

```console
$ cd /c/Program\ Files\ \(x86\)/Git/libexec/git-core/
$ patch < ~/git-difftool.patch
patching file `git-difftool'
```

さらに、`C:\Program Files (x86)\Git\libexec\git-core\git-mklink` を作ります。

```sh
#!/bin/sh

cmd.exe /c "mklink \"$2\" \"$1\"" > /dev/null
```

(このスクリプトは `/tmp/` といった msys 内のパスを Windows のパスに変換するために必要)


使い方
======

最初に、`.gitconfig` に difftool の設定をしておきます。[WinMerge] を利用するには次のようにしておきます。

```ini
[diff]
    tool = winmerge
[difftool winmerge]
    path = C:/Program Files (x86)/WinMerge/winmergeu.exe
    cmd = \"C:/Program Files (x86)/WinMerge/winmergeu.exe\" -r -u \"$LOCAL\" \"$REMOTE\"
```

GitBash を管理者権限で起動して、次のように実行します (Windows ではシンボリックリンクを作成するには管理者権限が必要)。

```console
$ git difftool -d --symlinks [<commit> [<commit>]]
```

ついでに `.gitconfig` にエイリアスを定義しておくと便利でしょう。

```ini
[alias]
    d = difftool -d --symlinks
```

どうぞご利用ください。


[WinMerge]: http://winmerge.org/
