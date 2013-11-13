---
layout: post
title: 'Jekyll で --watch の代わりに Grunt を使ってみるテスト'
tags: Jekyll Ruby Node.js
lang: ja
thumbnail: http://farm4.staticflickr.com/3741/10839091955_4415c94104_o.png
alternate:
  lang: en_US
  url: /en/blog/2013/06/25/jekyll-grunt/
seealso:
- 2012-09-20-moved-completed
- ja/2013-04-17-jekyll-pluralize
- 2012-12-25-jekyll-0-12-0
- 2012-10-15-static-site-js-css-cache
- 2012-10-29-liquid-drop
---
このブログでは [Jekyll] を使ってることは何度か書いたのだけど、いままで記事を書くときには `jekyll --auto` を実行した状態で書いていた。このようにしておくと、ファイルを書き換えたら自動的にサイトをビルドしてくれるようになる。ただ、このコマンドを実行してると CPU がグオーンと音を上げ始め、クアッドコアで CPU 使用率 25% に達するという地球に優しくない状態であった。

原因を調べてみると `directory_watcher` モジュールが犯人だった。このモジュールは、監視対象のディレクトリー配下の全ファイルに対して、毎秒、`File::Stat()` を実行する、という富豪的実装になっている。もちろん、ファイルの数が少ないときには問題なく動くんだけども、ファイルの数が増えると CPU を浪費してしまう。

たとえば、このサイトの場合、600 個以上の記事があって、Jekyll が 900 個のファイルを生成する。しかも、`.git` フォルダーの下には 5,000 個程度のファイルがある。ひどいことに、Jekyll 0.12 までのバージョンは、これらのファイルすべてを監視対象にする。毎秒 6,500 個のファイルを stat するわけだから、当然、CPU は振り切る。

Jekyll 1.0 になって、コマンドも `jekyll build --watch` に変わって、`_site` (サイトの出力先) や `.git` が監視対象から外れたので、パフォーマンスはだいぶ改善した。それでも自分の環境で常時 10% ぐらい CPU を消費し続けている。

ということで、`--watch` (もしくは `--auto`) オプションの代わりに、流行の [Grunt] を使ってみることにした。

Grunt の設定ファイル
====================

使っているバージョンやプラグインは次の通り。

* Jekyll 1.0.3
* Grunt 0.4.1
  * `grunt-shell-spawn` プラグイン
  * `grunt-contrib-watch` プラグイン

最初は、`grunt-shell-spawn` ではなく `grunt-jekyll` を使ってたんだけど、`grunt-jekyll` は Jekyll を実行中の途中経過を表示してくれないので使うのをやめた。

Grunt の使い方については [Getting started - Grunt] を見たほうが早いだろうから、ここでは `package.json` と `Gruntfile.js` を紹介する。

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

(Jekyll 0.12 までを使用している場合は、`jekyll build` を `jekyll` で置き換えるべし)


使い方
======

`grunt watch` を実行すると、ファイルの監視を始める。記事や HTML が編集されたら、`jekyll build` が実行されるようになっている。

しかし、Jekyll で監視するよりも CPU 消費量は小さいが・・・0 ではない・・・!?　と、ここで調べてみて気づいたんだけども、Grunt の watch は、ネイティブ API の `fs.watch()` を使ってファイルを監視していない!!!　`gaze` モジュールを使って定期的にファイルを stat しているだけだった。

これでは Ruby の `directory_watcher` と同じである。

どうやら、Node.js の `fs.watch()` は Mac OS でファイル名を取れなかった過去があるなど、歴史的に不安定であり、結局、stat で独自に監視する、という手順が一般的になったようだ。なんという罠。

[jekyll]: https://github.com/mojombo/jekyll
[Grunt]:  http://gruntjs.com/
[Getting started - Grunt]: http://gruntjs.com/getting-started