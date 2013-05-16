---
layout: post
title: Bugzilla に登録してあるバグをプログラムから更新する方法
tags:
  - Perl
lang: ja
seealso:
  - 2013-03-29-git-new-workdir
  - 2012-04-12-msysgit-utf8-2
  - 2012-03-19-perl-feature-extraction
  - 2010-02-23-perl-exif
  - 2008-06-03-perl-open
alternate:
  lang: en_US
  url: /en/blog/2013/05/17/bugzilla-hack/
---
会社で BTS として Bugzilla を使っているんだけど、修正したあとに手作業で Web インターフェースから書き込むのが面倒になってきたので、自動化してみた。

コミットしたとき (Git の場合は push したとき) に、コミットメッセージからバグ番号を読み取って、対応するバグにメッセージを書き込みつつ、FIXED にすればよい。

情報がなくて困ったのが、バグにコメントを書いたり、FIXED にする方法。この部分の処理を抜き出してみた。

```perl
#!/usr/bin/perl -I/path/to/bugzilla -I/path/to/bugzilla/lib

use strict;
use Bugzilla;
use Bugzilla::User;
use Bugzilla::Status;
use Bugzilla::Bug;
use utf8;

&update_bug(1, "ほげほげ");

# API document: http://www.bugzilla.org/docs/4.2/en/html/api/
sub update_bug {
    my ($bug_id, $text) = @_;

    # open bug
    my $bug = Bugzilla::Bug->new($bug_id);
    die $bug->error if defined $bug->error;

    # get user
    my $user = Bugzilla::User->new({name => 'admin@example.com'});
    die 'user not found!!!!' unless defined $user;

    # login
    Bugzilla->set_user($user);

    # comment to the bug
    $bug->add_comment($text);

    # FIXED
    $bug->set_bug_status(Bugzilla::Status->new({name => 'RESOLVED'}),
                         {resolution => 'FIXED'});

    # save to database
    $bug->update();
}
```

Bugzilla 4.2.5 で動作を確認している。

あとは、Git なら `post-receive` フックで、コミットログを解析して、この関数を呼ぶようにすればよい。

注意点:

  * Bugzilla がインストールされているサーバー上で動くことを前提としている。同一サーバーならパスワードなしで、特定のユーザーに su できるようだ。
  * `Bugzilla::Bug` はドキュメント化されていないので、バージョンアップしたら使えなくなる可能性がある。同じような機能の `Bugzilla::WebService::Bug` はドキュメントがあるんだけど、使おうとしたら `Test/Taint.pm` が必要だとか言われて面倒になったのでやめた。
