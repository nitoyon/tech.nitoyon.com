---
layout: post
title: 'Jekyll: Use Grunt instead of --watch option'
tags: Jekyll Ruby Node.js
lang: en
thumbnail: http://farm4.staticflickr.com/3741/10839091955_4415c94104_o.png
alternate:
  lang: ja_JP
  url: /ja/blog/2013/06/25/jekyll-grunt/
seealso:
- en/2013-04-17-jekyll-pluralize
- en/2013-02-27-livereloadx
- en/2009-04-05-irbweb-ruby-on-your-browser
---
I'm using [Jekyll] for building my site.  When I write a new entry, I have executed `jekyll --auto`. But I noticed that ruby consumes up to 25% of CPU on my quad core PC.

This problem is caused by `directory_watcher` module. It executes `File::Stat()` on all files under the given directory every one second! It works fine when the number of files is small, but as it grow up, it begins wasting our CPU.

For example, my site has over 600+ posts by which Jekyll generates 900 files. And more, there are 5000 files under `.git` dir. Suprisingly, Jekyll ~0.12 watches all files under the current directory, which means that it execute stat to these 6,500 files every one second.

Jekyll 1.0's `jekyll build --watch` doesn't watch `.git` and `_site` directory. Despite of such improvement, ruby still uses up to 10% of CPU.

So I decided to use [Grunt] instead of using `--watch` (or `--auto`) option.

Grunt config files
==================

I'm use following versions:

* Jekyll 1.0.3
* Grunt 0.4.1
  * `grunt-shell-spawn` plugin
  * `grunt-contrib-watch` plugin

At first, I used `grunt-jekyll` instead of `grunt-shell-spawn`, but `grunt-jekyll` plugin doesn't show Jekyll's output until it exits.

See [Getting started - Grunt] to setup Grunt.

Here is my `package.json` and `Gruntfile.js`.

package.json
------------

```json
{
  "name": "tech-ni",
  "version": "0.1.0",
  "devDependencies": {
    "grunt": "~0.4.1",
    "grunt-shell-spawn": "~0.2.4",
    "grunt-contrib-watch": "~0.4.4"
  }
}
```

Gruntfile.js
------------

```js
module.exports = function(grunt) {
  grunt.initConfig({
    pkg: grunt.file.readJSON('package.json'),
    shell: {
      jekyll: {
        command: 'jekyll build',
        options: {
          async: false
        }
      }
    },
    watch: {
      jekyll: {
        files: ['_posts/**/*.md', '_layout/*.html', '_includes/*.html'],
        tasks: ['shell:jekyll']
      }
    }
  });

  grunt.loadNpmTasks('grunt-shell-spawn');
  grunt.loadNpmTasks('grunt-contrib-watch');

  grunt.registerTask('default', ['shell:jekyll']);
};
```

(If you're using Jekyll ~0.12, replace `jekyll build` to `jekyll`)


How to Use
==========

By entering `grunt watch`, it starts watching files. When some posts or HTML files are modified, grunt executes `jekyll build`.

But CPU usage is not 0%. It turns out that `grunt-contrib-watch` doesn't use native watch API -- `fs.watch()`. It uses `gaze` module which execute `fs.statSync()` periodically.

Oh!! Nothing changes...

It seems that `fs.watch()` had many problems such as not reporting filenames on mac and executing `fs.stat()` became popular. Oh, hell!

[jekyll]: https://github.com/mojombo/jekyll
[Grunt]:  http://gruntjs.com/
[Getting started - Grunt]: http://gruntjs.com/getting-started