---
layout: post
title: Difference between fs.watch() and fs.watchFile()
tags: Node.js
lang: en
alternate:
  lang: ja_JP
  url: /ja/blog/2013/10/02/node-watch-impl/
seealso:
- en/2013-06-25-jekyll-grunt
- en/2013-04-17-jekyll-pluralize
- en/2013-07-09-symlink-dir-diff-on-windows
---
Node.js has two functions for file watching. `fs.watch()` and `fs.watchFile()`.

These functions look similar. What's the difference?


Official Document
=================

According to official [document (v0.8.0)](http://nodejs.org/docs/v0.8.0/api/fs.html#fs_fs_watchfile_filename_options_listener),

> ## fs.watchFile(filename, [options], listener)
>
> Stability: 2 - Unstable.  Use fs.watch instead, if available.
>
> Watch for changes on `filename`.
>
> ## fs.watch(filename, [options], [listener])
>
> Stability: 2 - Unstable.  Not available on all platforms.
>
> Watch for changes on `filename`, where `filename` is either a file or a directory.

we can say

* `fs.watch()` is recommended.
* `fs.watch()` is not available on all platforms.
* `fs.watch()` watches a file or a directory. `fs.watchFile()` watches a file.


ChangeLog
=========

According to [ChangeLog](https://github.com/joyent/node/blob/master/ChangeLog), I found that

* `fs.watchFile()` is older API which is implemented on v0.1.18 as `process.watchFile()`.
* `fs.watch()` is newer API which is implemented on v0.5.9.


Source Code
===========

I cannot found official information any more, so I looked at source code for more understanding.

fs.watch()
----------

Let's look at implementation of `fs.watch()`. (We use source code for [v0.10.19])

After I looked at [`lib/fs.js`] and [`src/fs_event_wrap.cc`], I found `fs.watch()` is implemented by `uv_fs_event_init()` function.

The functions whose name start with `uv` is defined by libuv. libuv is multi-platform support library for Node.js. It has features like asynchronous IO, thread pool, timer and so on.

So, look at `uv_fs_event_init()` function. I grepped under `deps/uv/src`. The results are as follows:

* unix\aix.c
* unix\cygwin.c
* unix\kqueue.c
* unix\linux-inotify.c
* unix\sunos.c
* win\fs-event.c

Each file has implementation for different platforms.

Platform         | How to implement
-----------------|---------------------------------
Linux            | inotify
MacOS、*BSD      | kqueue
Windows          | `ReadDirectoryChangesW()`
Solaris          | Event Ports
AIX              | (Not supported)
Cygwin           | (Not supported)

Conclusion: **fs.watch() uses native API**.


fs.watchFile()
--------------

Let's look at `fs.watchFile()`.

After I looked at [`lib/fs.js`] and [`src/node_stat_watcher.cc`], I found `fs.watchFile()` is implemented by `uv_fs_poll_start()` function.

OK. Let's read `uv_fs_poll_start()` defined in [`deps/uv/src/fs-poll.c`].

```c
int uv_fs_poll_start(uv_fs_poll_t* handle,
                     uv_fs_poll_cb cb,
                     const char* path,
                     unsigned int interval) {
  // snip initialization

  if (uv_fs_stat(loop, &ctx->fs_req, ctx->path, poll_cb))
    abort();
```

The point is `uv_fs_stat()`. This function executes  asynchronous `stat()`. The callback `poll_cb` is called when it completes.

Next, [`poll_cb()`].

```c
static void poll_cb(uv_fs_t* req) {
  // snip: trigger event, error handling, and so on

  /* Reschedule timer, subtract the delay from doing the stat(). */
  interval = ctx->interval;
  interval -= (uv_now(ctx->loop) - ctx->start_time) % interval;

  if (uv_timer_start(&ctx->timer_handle, timer_cb, interval, 0))
    abort();
}

```

First it analyzes the stat result, and then it starts next timer so that `timer_cb()` will be called `interval` later.

`timer_cb()` calls `uv_fs_stat()` again. I got it! `fs.stat()` is called periodically.


Conclusion: **fs.watchFile() periodically executes fs.stat()**.


Conclusion
==========

`fs.watch()`:

  * is newer API and recommended.
  * uses native watching functions supported by OS, so doesn't waste CPU on waiting.
  * doesn't support all platforms such as AIX and Cygwin.

`fs.watchFile()`:

  * is old API and not recommended.
  * calls stat periodically, so uses CPU even when nothing changes.
  * runs on any platforms.

[v0.10.19]: https://github.com/joyent/node/tree/v0.10.19
[`lib/fs.js`]: https://github.com/joyent/node/blob/v0.10.19/lib/fs.js
[`src/fs_event_wrap.cc`]: https://github.com/joyent/node/blob/v0.10.19/src/fs_event_wrap.cc#L102
[`src/node_stat_watcher.cc`]: https://github.com/joyent/node/blob/v0.10.19/src/node_stat_watcher.cc#L112
[`deps/uv/src/fs-poll.c`]: https://github.com/joyent/node/blob/v0.10.19/deps/uv/src/fs-poll.c#L56
[`poll_cb()`]: https://github.com/joyent/node/blob/v0.10.19/deps/uv/src/fs-poll.c#L139
