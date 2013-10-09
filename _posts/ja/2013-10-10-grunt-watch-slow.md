---
layout: post
title: grunt-contrib-watch が重いので grunt-este-watch を試したら幸せになった
tags: Node.js
lang: ja
alternate:
  lang: en_US
  url: /en/blog/2013/10/10/grunt-watch-slow/
seealso:
- ja/2013-10-02-node-watch-impl
- ja/2013-06-25-jekyll-grunt
- ja/2013-04-17-jekyll-pluralize
- ja/2013-02-27-livereloadx
---
最近、[Grunt] と [`grunt-contrib-watch`] を使っているのだけど、`grunt-contrib-watch` が CPU を消費しがちである。

watch 対象のファイルが少ないうちは `grunt-contrib-watch` は問題なく動くんだけども、ファイル数が増えてくると CPU の消費量が増えてくる。自分の環境では、1,000 個ぐらいのファイルを監視していると、常時 10% 程度 CPU を消費している。

この問題は既知であり、[FAQ](https://github.com/gruntjs/grunt-contrib-watch/#why-is-the-watch-devouring-all-my-memorycpu) には次のように書いている。

> たくさんのファイルを監視している場合、デフォルトの `interval` の値が小さすぎるかもしれない。`options: { interval: 5007 }` のようにして増やしてみてほしい。詳しくは issues [#35](https://github.com/gruntjs/grunt-contrib-watch/issues/35) と [#145](https://github.com/gruntjs/grunt-contrib-watch/issues/145) を参照のこと (※日本語訳は私によるもの)
>> Another reason if you're watching a large number of files could be the low default `interval`. Try increasing with `options: { interval: 5007 }`. Please see issues [#35](https://github.com/gruntjs/grunt-contrib-watch/issues/35) and [#145](https://github.com/gruntjs/grunt-contrib-watch/issues/145) for more information.



なぜ CPU を消費するのか？
===========================

`grunt-contrib-watch` はファイルの監視に [`gaze`] というモジュールを使用している。

`gaze` さんがファイルを監視するときには、ネイティブな監視 API の `fs.watch()` だけでなく、`fs.watchFile()` を併用している。`fs.watchFile()` は定期的に `fs.stat()` を実行しているだけであり、監視対象のファイルに変化がなくても CPU を消費する (詳しくは {% post_link ja/2013-10-02-node-watch-impl %} をご覧あれ)。そのため、ファイルが増えるに従って、CPU の消費も激しくなるのである。

なんで `gaze` は CPU 負荷が高くなる `fs.watchFile()` を利用しているのだろうか。それには歴史的な理由があるらしく、[chokidar/README.md](https://github.com/paulmillr/chokidar) に `fs.watch()` についての愚痴が書いてある。

> Node.js の `fs.watch` は...
> 
> * Mac でファイル名を報告してくれない。
> * Mac で TextMate2 のようなエディターで編集したときに何もイベントが発生しない
> * ときどき、2 重にイベントを報告する。
> * 利用価値のない `rename` イベントしかない。
> * [他にもたくさんの問題](https://github.com/joyent/node/search?q=fs.watch&type=Issues)がある。
>
> (※日本語訳は私によるもの)
>
>> Node.js `fs.watch`:
>> 
>> * Doesn't report filenames on mac.
>> * Doesn't report events at all when using editors like TextMate2 on mac.
>> * Sometimes report events twice.
>> * Has only one non-useful event: `rename`.
>> * Has [a lot of other issues](https://github.com/joyent/node/search?q=fs.watch&type=Issues)



どうやって回避したか
====================

CPU 負荷が耐えられなくなったので、`grunt-contrib-watch` を諦めてみることにした。

検索して探したところ、[`grunt-este-watch`] が便利そうであった。[`grunt-este-watch/README.md`](https://github.com/steida/grunt-este-watch/blob/master/README.md) には次のように書いてあった。

> *公式の grunt-contrib-watch の問題点は何か？*
>
> 遅い、そして、バグがある。というのも、公式のものは歴史的な理由で fs.watchFile と fs.watch を組み合わせて使っている。
> Node の 0.9.2 以降では、fs.watch には問題はない。
> 
> [github.com/steida/este](http://github.com/steida/este) では最大限のパフォーマンスと安定性が必要だったので、新しい Node.js の file watcher を作る必要があった。この watcher は Mac, Linux, Windows で継続的にテストしている (※日本語訳は私によるもの)。
>
>> *What's wrong with official grunt-contrib-watch?*
>>
>> It's slow and buggy, because it uses combination fs.fileWatch and fs.watch, for
>> historical reason. From Node 0.9.2+, fs.watch is ok.
>> 
>> [github.com/steida/este](http://github.com/steida/este) Needs maximum performance and
>> stability, so that's why I had to create yet another Node.js file watcher.
>> This watcher is continuously tested on Mac, Linux, Win platforms.

この作者が試す限り問題はないようなので、それを信じて試してみた。


設定例
------

ためしにこのブログのビルド環境に組み込んでみた。[`Gruntfile.js`](https://github.com/nitoyon/tech.nitoyon.com/blob/b1fd0f12a6318b200390d8a2934d5cb66e46d454/Gruntfile.js) がこちら。

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

`grunt-este-watch` の設定は `grunt-contrib-watch` とかなり違う点に注意。

`grunt-este-watch` は監視するディレクトリの一覧を記述する。ディレクトリ配下のファイルが変更されたら、コールバック関数が呼び出される。

自分のコールバック関数では、単純に `'shell:jekyll_build'` と返しているので、ファイルが更新されたら `grunt` は `shell:jekyll_build` タスクを実行してくれる。その気になれば `filepath` 引数に応じて、返すタスク名を変えることもできる。

`'*'` ってのは「すべての拡張子」を意味する。特定の拡張子を指定することもできる。[grunt-este-watch/README.md](https://github.com/steida/grunt-este-watch/blob/master/README.md) のサンプルを見ると分かりやすい。

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

[`grunt-contrib-watch`] の CPU 負荷が高くて困っている人はぜひ試してみてほしい。

[Grunt]:  http://gruntjs.com/
[`grunt-contrib-watch`]: https://github.com/gruntjs/grunt-contrib-watch
[`gaze`]: https://github.com/shama/gaze
[`grunt-este-watch`]: https://github.com/steida/grunt-este-watch/
