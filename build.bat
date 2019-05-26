
docker run ^
  --rm ^
  --volume="%~dp0:/srv/jekyll" ^
  --volume="%~dp0/vendor/bundle:/usr/local/bundle" ^
  -it ^
  jekyll/jekyll:3.8 ^
  jekyll build %*