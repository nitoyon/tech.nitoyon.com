#!/usr/local/bin/ruby

# Redirector
# ==========
#
# /blog/2008/01/first_post.html => /en/blog/2008/01/02/first-post/
#
# Assumption
# ----------
#
# * URL 'blog/a/b.html' is redirected to 'blog.cgi/a/b.html'
# * ruby is installed at /usr/local/bin/ruby

require 'cgi'

posts = {
  "/2008/01/first_post.html" => "/2008/01/02/first-post/",
  "/2008/01/as3query_alpha.html" => "/2008/01/14/as3query-alpha/",
  "/2008/01/introduction_of_spark_project.html" => "/2008/01/17/introduction-of-spark-project/",
  "/2008/01/heredocument_in_as30.html" => "/2008/01/26/heredocument-in-as30/",
  "/2008/05/keynote_like_cube_transition.html" => "/2008/05/12/keynote-like-cube-transition/",
  "/2008/05/google_maps_api_for_flash_with.html" => "/2008/05/18/google-maps-api-for-flash-with/",
  "/2008/05/google_maps_globe.html" => "/2008/05/23/google-maps-globe/",
  "/2008/05/google_earth_control_in_google.html" => "/2008/05/26/google-earth-control-in-google",
  "/2008/06/color_illusion_generator_released.html" => "/2008/06/26/color-illusion-generator-released/",
  "/2009/02/50_polygons_mona_lisa_in_as3.html" => "/2009/02/17/50-polygons-mona-lisa-in-as3/",
  "/2009/03/processing_firecube_example_ported_to_actionscript_30.html" => "/2009/03/25/processing-firecube-example-ported-to-actionscript-30/",
  "/2009/04/irbweb_ruby_on_your_browser.html" => "/2009/04/05/irbweb-ruby-on-your-browser/",
}

# get path from PATH_INFO
path = ENV['PATH_INFO'] || '/'

redirect_to = '/en/blog'
if posts.key? path
  redirect_to << posts[path]
else
  redirect_to << path
end

print CGI.new.header({
  'status' => '301 Moved Permanently',
  'Location' => redirect_to
})
