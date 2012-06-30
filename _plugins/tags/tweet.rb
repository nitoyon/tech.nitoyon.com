# Tweet Tag Plugin for Jekyll
# ===========================
#
# How to use
# ----------
#
#   1. Install this script to `_plugin` folder.
#   2. Create cache directory `_caches/tweet`.
#
# Embed tweet
# -----------
#
#     {% tweet https://twitter.com/twitterapi/status/136541709390708736 %}
#     {% tweet 136541709390708736 %}
#
# License
# -------
#
# Copyright 2012, nitoyon. All rights reserved.
# BSD License.

module Jekyll

  class TweetTag < Liquid::Tag
    def initialize(tag_name, tweet, tokens)
      super
      tweet.strip!
      if tweet =~ /^\d+$/
        @tweet_id = tweet
      elsif tweet =~ /^https?:\/\/twitter\.com\/[^\/]+\/status\/(\d+)$/
        @tweet_id = $1
      else
        @tweet_id = nil
      end
    end

    def render(context)
      if @tweet_id.nil?
        "(invalid tweet tag parameter)"
      else
        tweet = self.load_tweet_with_cache(@tweet_id, context)
        tweet['html']
      end
    end

    def load_tweet_with_cache(tweet_id, context)
      require 'json'

      caches_dir = File.join(context.registers[:site].source, '_caches/tweet')
      cache_path = File.join(caches_dir, "#{@tweet_id}.json")
      unless FileTest.directory?(caches_dir)
        puts "Cache directory doesn't exist: #{caches_dir}"
        return "Cache directory doesn't exist: #{caches_dir}"
      end

      json = nil
      if FileTest.file?(cache_path)
        open(cache_path) { |f| return JSON.parse(f.read) }
      end

      json_str = self.load_tweet(tweet_id)
      json = JSON.parse(json_str)
      open(cache_path, 'w') { |f| f.write(json_str) }
      json
    end

    def load_tweet(tweet_id)
      require 'net/http'
      Net::HTTP.start('api.twitter.com', 80) { |http|
        puts "load tweet: #{tweet_id}"
        response = http.get("/1/statuses/oembed.json?id=#{tweet_id}")
        puts "loaded tweet: #{tweet_id}"
        return response.body
      }
    end
  end
end

Liquid::Template.register_tag('tweet', Jekyll::TweetTag)
