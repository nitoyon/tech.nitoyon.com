tech-ni source code
===================

"tech-ni" is a web site published under:

  - http://tech.nitoyon.com/ (てっく煮)


Initialize
----------

    $ git clone https://github.com/nitoyon/tech.nitoyon.com.git
    $ cd tech.nitoyon.com
    $ git new-workdir . _site html
    $ npm install
    $ npm install -g grunt-cli

(ref) [git-new-workdir](https://github.com/git/git/blob/master/contrib/workdir/git-new-workdir), [git-new-workdir-win](https://github.com/dansmith65/git/blob/master/contrib/workdir/git-new-workdir-win)


How to Build
------------

Generate only modified pages when file is modified.

    $ grunt watch

Generate only modified pages.

    $ grunt build

Generate all pages.

    $ jekyll rebuild

* Post and Page are generated when source file is modified.
* Archive and Lang are generated when page's yaml front matter or post's yaml front matter is modified.


Build Requirements
------------------

* Node.js 0.8
  * grunt-cli
* Ruby 1.9.3
  * Jekyll 1.0.3
  * hparser
  * Sass 3.2
* Python 2.7
  * Pygments
