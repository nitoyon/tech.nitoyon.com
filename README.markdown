tech-ni source code
===================

"tech-ni" is a web site published under:

  - http://tech.nitoyon.com/ (てっく煮)


Initialize
----------

    $ git clone https://github.com/nitoyon/tech.nitoyon.com.git
    $ cd tech.nitoyon.com
    $ git new-workdir . _site html
    $ git checkout .; git clean -d -f
    $ npm install
    $ npm install -g grunt-cli

(ref) [git-new-workdir](https://github.com/git/git/blob/master/contrib/workdir/git-new-workdir), [git-new-workdir-win](https://github.com/dansmith65/git/blob/master/contrib/workdir/git-new-workdir-win)


How to Build
------------

When file is modified, generate only modified pages and notify to browser (http://localhost:35729/).

    $ grunt

Generate only modified pages when file is modified.

    $ grunt watch

Generate only modified pages.

    $ grunt build

Generate all pages.

    $ grunt rebuild

* Post and Page are generated when source file is modified.
* Archive and Lang are generated when page's yaml front matter or post's yaml front matter is modified.


Build Requirements
------------------

* Node.js 0.10.18
  * grunt-cli
* Ruby 2.0.0
  * Jekyll 1.3.0
  * hparser
  * Compass 0.12.0
  * Sass 3.2.12
* Python 2.7
  * Pygmentize 1.6
