@echo off
REM Execute jekyll with docker
REM
REM ex) build site
REM   docker-jekyll.bat build --config _config.yml,_config.ja.yml
REM
REM ex) build and start server
REM   docker-jekyll.bat serve --config _config.yml,_config.ja.yml
REM
REM ex) build and start server (livereload enabled)
REM   docker-jekyll.bat serve -l --config _config.yml,_config.ja.yml
REM
REM ex) start bash
REM   docker-jekyll.bat bash

if /i %1 == bash (
  set CMD=bash
  echo Starting bash...
) else (
  set CMD=jekyll %*
)


docker run ^
  --rm ^
  --volume="%~dp0/../:/srv/jekyll" ^
  --volume="%~dp0/../vendor/bundle:/usr/local/bundle" ^
  -p 4000:4000 ^
  -p 35729:35729 ^
  -it ^
  jekyll/jekyll:3.8 ^
  %CMD%
