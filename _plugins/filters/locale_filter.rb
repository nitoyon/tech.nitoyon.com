module Jekyll
  module Filters
    # Convert a text using locale file.
    #
    # input - key name when string is nil, parameter otherwise.
    # string - key name or nil.
    #
    # _config.yml file:
    #     locale:
    #       en:
    #         hello: "Hello world"
    #         hello2: "Hello world '$0'"
    #
    # Liquid:
    #     {{'hello' | t}}            # => Hello world
    #     {{'foo' | t:'hello2'}}     # => Hello world 'foo'
    #
    # Returns the translated String.
    def t(input, string=nil)
      lang = 'en'
      lang = @context['page']['lang'] if @context['page'].has_key?('lang')
      site = @context.registers[:site]
      param = string.nil? ? nil : input
      key = string.nil? ? input : string
      Jekyll::Locales::translate(site, lang, key, nil, param)
    end
  end

  class Locales
    # Convert a text using locale file.
    #
    # config - Site#config
    # lang - language name
    # key - key name
    # default_value - (optional) default value when locale is not defined
    # param - (optional) parameter for the value
    #
    # Returns the translated String.
    #
    # (ex) _config.yml file:
    #     locale:
    #       ja:
    #         hello: "こんにちは世界"
    #       en:
    #         hello: "Hello world"
    #         hello2: "Hello world '$0'"
    #         date: 'Date=%v'
    #
    #     translate(c, 'en', 'hello')            # => Hello world
    #     translate(c, 'ja', 'hello')            # => こんにちは世界
    #     translate(c, 'en', 'hello2', 'foo')    # => Hello world 'foo'
    #     translate(c, 'fr', 'hello', nil, '!')  # => !
    #     translate(c, 'en', 'date', Time.now)   # => 01-JAN-2013
    def self.translate(site, lang, key, default_value=nil, param=nil)
      unless site.data.has_key?('locale') && site.data['locale'].has_key?(lang)
        return "(UNKNOWN TEXT: locale config for #{lang} not found #{data})"
      end

      locale = site.data['locale'][lang]
      begin
        if key.nil?
          return "(nil)"
        elsif key.class != String
          "(UNKNOWN CLASS: #{key.class})"
        end

        # get value
        if locale.has_key? key
          value = locale[key]
        else
          value = default_value
          return "(UNKNOWN KEY: #{key} for #{lang})" if value.nil?
        end

        # apply param
        if param.nil?
          return value
        elsif param.class == String
          return value.gsub('$0', param)
        elsif param.class == Time
          return param.strftime(value)
        else
          return "(UNKNOWN PARAM CLASS: #{param.class})"
        end
      rescue => e
        "(ERROR: #{key} for #{lang} #{e.message})"
      end
    end
  end
end