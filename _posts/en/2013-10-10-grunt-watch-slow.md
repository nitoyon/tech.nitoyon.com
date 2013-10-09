---
layout: post
title: 'When grunt-contrib-watch uses too much CPU, try grunt-este-watch'
tags: Node.js
lang: en
alternate:
  lang: ja_JP
  url: /ja/blog/2013/10/10/jekyll-watch-slow/
seealso:
- en/2013-10-02-node-watch-impl
- en/2013-06-25-jekyll-grunt
- en/2013-04-17-jekyll-pluralize
- en/2013-02-27-livereloadx
- en/2009-04-05-irbweb-ruby-on-your-browser
---
I used [Grunt] and [`grunt-contrib-watch`] in my project. 

Although `grunt-contrib-watch` works fine when the number of files is small, but as it grows up, `grunt-contrib-watch` starts using too much CPU. For example, when `grunt-contrib-watch` is watching about 1,000 files, node always uses 10% of my CPU.

This is known issue. Look at the [FAQ](https://github.com/gruntjs/grunt-contrib-watch/#why-is-the-watch-devouring-all-my-memorycpu):

> Another reason if you're watching a large number of files could be the low default `interval`. Try increasing with `options: { interval: 5007 }`. Please see issues [#35](https://github.com/gruntjs/grunt-contrib-watch/issues/35) and [#145](https://github.com/gruntjs/grunt-contrib-watch/issues/145) for more information.


What causes high CPU usage?
===========================

`grunt-contrib-watch` uses [`gaze`] module to watch files.

This module uses not only `fs.watch()` (native API) but also `fs.watchFile()` which periodically executes `fs.statSync()` (read {% post_link en/2013-10-02-node-watch-impl %} for details).

Why does `gaze` use `fs.watchFile()`? [chokidar/README.md](https://github.com/paulmillr/chokidar) says `fs.watch()` had many problems.

> Node.js `fs.watch`:
> 
> * Doesn't report filenames on mac.
> * Doesn't report events at all when using editors like TextMate2 on mac.
> * Sometimes report events twice.
> * Has only one non-useful event: `rename`.
> * Has [a lot of other issues](https://github.com/joyent/node/search?q=fs.watch&type=Issues)


How do I avoid it?
==================

Use [`grunt-este-watch`] instead of [`grunt-contrib-watch`].

Let's read [`grunt-este-watch/README.md`](https://github.com/steida/grunt-este-watch/blob/master/README.md).

> *What's wrong with official grunt-contrib-watch?*
>
> It's slow and buggy, because it uses combination fs.fileWatch and fs.watch, for
> historical reason. From Node 0.9.2+, fs.watch is ok.
> 
> [github.com/steida/este](http://github.com/steida/este) Needs maximum performance and
> stability, so that's why I had to create yet another Node.js file watcher.
> This watcher is continuously tested on Mac, Linux, Win platforms.

I'm using `grunt-este-watch` now. It uses no CPU when watching. Nice!


Example
-------

Here is my [`Gruntfile.js`](https://github.com/nitoyon/tech.nitoyon.com/blob/b1fd0f12a6318b200390d8a2934d5cb66e46d454/Gruntfile.js):

```javascript
module.exports = function(grunt) {
  grunt.initConfig({
    pkg: grunt.file.readJSON('package.json'),
    shell: {
      jekyll_build: {
        command: 'jekyll build'
      },
      // snip
    },
    // snip
    esteWatch: {
      options: {
        dirs: ['./', '_posts/*/', '_layouts', '_includes',
               'javascript/**/', 'apollo/tutorial',
               '_plugins/**/', 'stylesheets', 'javascripts'],
        livereload: {
          enabled: false
        }
      },
      '*': function(filepath) { return 'shell:jekyll_build' }
    }
  });
```

`grunt-este-watch`'s configuration is quite different from `grunt-contrib-watch`'s.

`grunt-este-watch` requires directory list to watch. When any file under watched directory is modified, callback function is called.

My callback function returns `'shell:jekyll_build'`, so `grunt` executes `shell:jekyll_build` when watched files are modified. We can check `filepath` argument to determine the tasks returned.

`'*'` means all extensions. We can register callback to specified extension. There is a good example on [grunt-este-watch/README.md](https://github.com/steida/grunt-este-watch/blob/master/README.md).

```javascript
    coffee: function(filepath) {
      var files = [{
        expand: true,
        src: filepath,
        ext: '.js'
      }];
      grunt.config(['coffee', 'app', 'files'], files);
      grunt.config(['coffee2closure', 'app', 'files'], files);
      return ['coffee:app', 'coffee2closure:app'];
    },
    // snip
    css: function(filepath) {
      if (grunt.option('stage')) {
        return 'cssmin:app';
      }
    }
```

Enjoy!

[Grunt]:  http://gruntjs.com/
[`grunt-contrib-watch`]: https://github.com/gruntjs/grunt-contrib-watch
[`gaze`]: https://github.com/shama/gaze
[`grunt-este-watch`]: https://github.com/steida/grunt-este-watch/
