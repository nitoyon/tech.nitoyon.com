---
layout: post
title: Jekyll のカテゴリーとタグの指定方法 3 パターン
tags: Jekyll
lang: ja
thumbnail: http://farm4.staticflickr.com/3741/10839091955_4415c94104_o.png
alternate:
  lang: en_US
  url: /en/blog/2013/04/17/jekyll-pluralize/
seealso:
  - 2012-09-20-moved-completed
  - 2012-12-25-jekyll-0-12-0
  - 2012-10-29-liquid-drop
  - 2008-12-02-ubygems
  - 2007-12-07-ruby-abc2
  - 2007-12-03-ruby-abc
---
Jekyll で記事にカテゴリーやタグを設定するには YAML の部分に書けばいいんだけど、指定方法が 3 通りもあって複雑だったのでまとめておく。

Jekyll 0.12.0 を前提に書いてるけど、将来的に大きな変更が入るとは思いにくい。


(1) 単数形を使う
================

単数形 (`category`・`tag`) で指定したときは 1 つだけしか指定できない。

```yaml
---
category: Foo
tag: Bar
```

上の例では、`Foo` というカテゴリー、`Bar` というタグを設定したことになる。

1 つしか指定できないので、

```yaml
---
category: Foo Bar
tag: Bar, Baz
```

のようにカンマやスペースで区切ったとしても、`Foo Bar` という名前のカテゴリー、`Bar, Baz` という名前のタグが指定されたものと解釈される。


(2) 複数形に文字列を指定する
============================

複数形 (`categories`・`tags`) に文字列を与えると、スペース区切りで複数指定できる。

```yaml
---
categories: Foo Bar
tags: Bar Baz
```

この例では、カテゴリーは `Foo` と `Bar`、タグは `Bar` と `Baz` の 2 つずつ指定されたものとみなされる。

つまり、この書き方ではスペースを含むカテゴリー名やタグ名は指定できない。スペースを含めたいなら、次で紹介する「複数形＋配列」で指定する方法を使うのがよい。前述の「単数形」の指定を使ってもよいけど、個数を増やしたときに無駄にハマりそうなので、複数形で統一したほうが分かりやすいと思う。


(3) 複数形に配列を指定する
==========================

複数形 (`categories`・`tags) に文字列の配列を渡すこともできる。

```yaml
---
categories:
- Foo Bar
- AA,BBB
tags:
- Bar
- Baz, AAA
```

上の指定では、カテゴリーは `Foo Bar` と `AA,BBB`、タグは `Bar Baz` と `AAA` の 2 つずつが指定されたものと解釈される。名前にスペースやカンマを含めることが可能。

次のようにも書けるけど、この場合は YAML の制限でカンマを含む名前は指定できない。

```yaml
---
categories: [Foo Bar, AABBB]
tags: [Bar Baz, AAA]
```


該当箇所のソースを読んでみる
============================

ソースを読んだほうが早いかもしれない。

[lib/jekyll/core_ext.rb](https://github.com/mojombo/jekyll/blob/9d814a4eb7b59ce617569b40a19c3c183fecda33/lib/jekyll/core_ext.rb) の `Hash#pluralized_array` を見ればよい。

この関数が `self.data.pluralized_array("tag", "tags")` のように呼ばれる。

```ruby
class Hash

  # Read array from the supplied hash favouring the singular key
  # and then the plural key, and handling any nil entries.
  #   +hash+ the hash to read from
  #   +singular_key+ the singular key
  #   +plural_key+ the singular key
  #
  # Returns an array
  def pluralized_array(singular_key, plural_key)
    hash = self
    if hash.has_key?(singular_key)
      array = [hash[singular_key]] if hash[singular_key]
    elsif hash.has_key?(plural_key)
      case hash[plural_key]
      when String
        array = hash[plural_key].split
      when Array
        array = hash[plural_key].compact
      end
    end
    array || []
  end
```

singular が単数形、plural が複数形。

ビルトインの `Hash` にメソッドを追加するあたりがなんともアグレッシブ。


まとめ
======

親切な計らいのおかげで、かえって悩むことが増えそうにも思える不思議な仕様・・・。
