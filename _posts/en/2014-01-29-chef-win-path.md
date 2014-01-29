---
layout: post
title: "Chef Console: avoid multiple ruby problem"
lang: en
thumbnail: http://farm8.staticflickr.com/7316/10710273026_68972312f0_o.jpg
alternate:
  lang: ja_JP
  url: /ja/blog/2014/01/18/chef-win-path/
---
The [Chef](http://www.getchef.com/) installer for Windows adds `ruby.exe` and to `PATH`. If you have installed ruby environment, which ruby is used when you enter `ruby` to your MS-DOS prompt? 

To avoid such problem, I created a Chef console with a simple bat file.


Chef adds two folders to PATH
=============================

When you install Chef client (http://www.getchef.com/chef/install/), many files are deployed to `C:\opscode\chef`  and the following 2 folders are added to `PATH`:

  * `C:\opscode\chef\bin`

    Chef related programs such as `chef-solo`, `knife`.

  * `C:\opscode\chef\embedded\bin`

    UNIX related programs such as `ruby.exe`, `perl.exe`, `ls.exe`, `cat.exe`.


Conflicts with existing Ruby environment
========================================

I have `ruby.exe` in `C:\Ruby200-x64\bin` which is added to `PATH`.

Which ruby is used when I run `ruby` or `gem install xxxx` from my MS-DOS prompt? 

If we first install Ruby and then install Chef, `C:\Ruby200-x64\bin\gem` is executed.

If we first install Chef and then install Ruby, `C:\opscode\chef\embedded\bin\gem` is executed.

It's very confusing.


Let's use Chef console
======================

To solve this problem, I created a "Chef console".

1. Create a bat file
--------------------

Save following file as `C:\opscode\chefenv.bat`.


```bat
@ECHO OFF

SET PATH=c:\opscode\chef\bin;c:\opscode\chef\embedded\bin
SET PATH=%PATH%;c:\windows\system32;c:\windows

title Chef Env
chef-solo -v
```


2. Create a shortcut file
-------------------------

Create a shortcut file to this bat.

  * Target: `C:\Windows\System32\cmd.exe /K C:\opscode\chefenv.bat`
  * Start in: Anywhere. (My document, path to chef repository and so on)

(`/K` means "Carries out the command specified by string and continues.")


How to use
==========

When you double click the shortcut file, a command prompt appears with restricted `PATH`.

{% image http://farm6.staticflickr.com/5527/11980775965_c14b1872a6.jpg, 677, 493 %}

You can execute `chef-solo` and `knife`.

Now, you can safely remove `c:\opscode\chef\bin` and `C:\opscode\chef\embedded\bin` from `PATH`.

Let's enjoy!
