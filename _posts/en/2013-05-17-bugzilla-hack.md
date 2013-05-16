---
layout: post
title: "Bugzilla: Edit bug status using Perl script"
tags:
  - Perl
lang: en
alternate:
  lang: ja_JP
  url: /ja/blog/2013/05/17/bugzilla-hack/
---
I wrote a perl script which adds a comment and modify status of bug in Bugzilla. This script is useful if you want to fix a bug automatically with a commit log.

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

Tested on Bugzilla 4.2.5.

When you are using Git, call this subroutine from `post-receive` hook.

Warnings:

  * This script must be executed on the server Bugzilla installed.
  * I'm using undocumented module, `Bugzilla::Bug`. At first, I tried to use `Bugzilla::WebService::Bug` (documented), but it depends on `Test/Taint` module and my server doesn't have the module.
