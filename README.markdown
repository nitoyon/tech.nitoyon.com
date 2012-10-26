tech-ni source code
===================

"tech-ni" is a web site published under:

  - http://tech.nitoyon.com/ (てっく煮)


Initialize
----------

    $ git clone git@github.com:nitoyon/tech.nitoyon.com.git
    $ git submodule init
    $ git submodule update
    $ cd _site
    $ git checkout html


How to Build
------------

Generate all pages.

    $ jekyll

Generate only modified pages.

    $ jekyll --server --auto

* Post and Page are generated when source file is modified.
* Archive and Lang are generated when page's yaml front matter or post's yaml front matter is modified.


Build Requirements
------------------

* Ruby 1.9.3
  * Jekyll (mojombo/jekyll@fa8400ab61cb8df176f9fb2ec52d85f93c7418a7)
  * hparser (hotchpotch/hparser@4fbeefc8becc45ed18bf374bec9a2d862db473d5)
  * Sass 3.2
* Python 2.7
  * Pygments
