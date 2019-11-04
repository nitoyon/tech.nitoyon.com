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
    $ jekyll build --config _config.yml,_config.ja.yml
    $ jekyll build --config _config.yml,_config.en.yml

(ref) [git-new-workdir](https://github.com/git/git/blob/master/contrib/workdir/git-new-workdir), [git-new-workdir-win](https://github.com/dansmith65/git/blob/master/contrib/workdir/git-new-workdir-win)


Build Requirements
------------------

* Jekyll 3.8.6 (with docker image `jekyll/jekyll:3.8.6`)
* hparser
* redcarpet


Build using docker
-------------------

Use `_scripts/docker-jekyll.bat` (Windows only).


