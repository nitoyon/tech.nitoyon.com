---
layout: post
title: 3 ways to specify categories and tags in Jekyll
tags: Jekyll
lang: en
thumbnail: http://farm4.staticflickr.com/3741/10839091955_4415c94104_o.png
alternate:
  lang: ja_JP
  url: /ja/blog/2013/04/17/jekyll-pluralize/
---
To specify categories and tags, you should write in [YAML front matter](https://github.com/mojombo/jekyll/wiki/yaml-front-matter). It's so complicated because there are 3 ways to specify it.

This article is targeted on Jekyll 0.12.0.


(1) Use singular key
====================

Use singular key (such as `category` or `tag`), then we can specify at most 1 category or tag.

```yaml
---
category: Foo
tag: Bar
```

In the above example, we specify a category named `Foo` and a tag named `Bar`.

Even if we write as follows:

```yaml
---
category: Foo Bar
tag: Bar, Baz
```

we'll get a tag named `Foo Bar` and a category named `Bar, Baz`.


(2) Use string with plural key
==============================

Use plural key (such as `categories` or `tags`) and a space-separated string value.

```yaml
---
categories: Foo Bar
tags: Bar Baz
```

In the above example, we get 2 categories (`Foo` and `Bar`) and 2 tags (`Bar` and `Baz`).

We cannot specify name which contains a space character. If you wants, use the next pattern "plural + string array".


(3) Use an array of string with plural key
==========================================

Use plural key (such as `categories` and `tags) and an array of string value.

```yaml
---
categories:
- Foo Bar
- AA,BBB
tags:
- Bar
- Baz, AAA
```

In the above example, we get 2 categories (`Foo Bar` and `AA,BBB`) and 2 tags (`Bar Baz` and `AAA`).

We can specify following, but in this case, we cannot specify name which contains a comma character.

```yaml
---
categories: [Foo Bar, AABBB]
tags: [Bar Baz, AAA]
```


Read Jekyll's source code
=========================

To understand this complecated specification, reading the source code would be helpful.

See `Hash#pluralized_array` method in [lib/jekyll/core_ext.rb](https://github.com/mojombo/jekyll/blob/9d814a4eb7b59ce617569b40a19c3c183fecda33/lib/jekyll/core_ext.rb).

This method is called like `self.data.pluralized_array("tag", "tags")`.

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

