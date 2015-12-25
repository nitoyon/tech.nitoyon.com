@echo off

echo checkout
git checkout _posts

echo htn to md
ruby -I ..\..\hotchpotch\hparser\lib _scripts\convert_hatena_to_md.rb _posts\ja\*.htn

echo jekyll
call bundle exec grunt rebuild
