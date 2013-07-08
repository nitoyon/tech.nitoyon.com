---
layout: post
title: Use symlinks in git difftool --dir-diff on Windows
lang: en
thumbnail: http://farm4.staticflickr.com/3792/9191502091_5f4e156b87_o.jpg
alternate:
  lang: ja_JP
  url: /ja/blog/2013/07/09/symlink-dir-diff-on-windows/
---
I like `git difftool --dir-diff` because it checks out the modified files to a temporary directory and executes diff tool with directory pathes.

On Unix and MacOS, `git difftool --dir-diff` create a symbolic link to the working directory if a right-hand file has the same SHA1 as the file in the working directory.  It's very useful when we modify right-hand files with a difftool.

On Windows, instead of creating symbolic links, `git difftool --dir-diff` copy back right-hand files to working directory after difftool program exits.  I want to use symlinks on Git for Windows like Unix and MacOS.


Quick Hack Patch
================

Environment: Git for Windows 1.8.3 and Windows 7 (64bit).

Patch for `C:\Program Files (x86)\Git\libexec\git-core\git-difftool`.

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

Save this patch to somewhere, and run GitBash as administrator.

```console
$ cd /c/Program\ Files\ \(x86\)/Git/libexec/git-core/
$ patch < ~/git-difftool.patch
patching file `git-difftool'
```

Create a file on `C:\Program Files (x86)\Git\libexec\git-core\git-mklink`:

```sh
#!/bin/sh

cmd.exe /c "mklink \"$2\" \"$1\"" > /dev/null
```

(This script is necessary for converting `/tmp/` directory to Windows path)


How to Use
==========

First, configure difftool on `.gitconfig`. For example, set [WinMerge] as difftool.

```ini
[diff]
    tool = winmerge
[difftool winmerge]
    path = C:/Program Files (x86)/WinMerge/winmergeu.exe
    cmd = \"C:/Program Files (x86)/WinMerge/winmergeu.exe\" -r -u \"$LOCAL\" \"$REMOTE\"
```

Run GitBash as an administrator, and enter following command.

```console
$ git difftool -d --symlinks [<commit> [<commit>]]
```

(On Windows, administrator privileges is required to create symbolic links)

If you want, create an alias on `.gitconfig`.

```ini
[alias]
    d = difftool -d --symlinks
```

Enjoy.


[WinMerge]: http://winmerge.org/
