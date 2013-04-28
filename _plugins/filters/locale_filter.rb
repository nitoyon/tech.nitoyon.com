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
    #     {{'foo' | t:hello2}}       # => Hello world 'foo'
    #
    # Returns the translated String.
    def t(input, string=nil)
      lang = 'en'
      lang = @context['page']['lang'] if @context['page'].has_key?('lang')
      config = @context.registers[:site].config
      Jekyll::Locales::translate(config, lang, input, string)
    end
  end

  class Locales
    # Convert a text using locale file.
    #
    # config - Site#config
    # lang - language name
    # input - key name when string is nil, parameter otherwise.
    # string - key name or nil.
    # default - returned value when key is not found
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
    #
    #     translate(c, 'en', 'hello')            # => Hello world
    #     translate(c, 'ja', 'hello')            # => こんにちは世界
    #     translate(c, 'en', 'foo', 'hello2')    # => Hello world 'foo'
    #     translate(c, 'fr', 'hello', nil, '!')  # => !
    def self.translate(config, lang, input, string=nil, default=nil)
      unless config.has_key?('locale') && config['locale'].has_key?(lang)
        return "(UNKNOWN TEXT: locale config for #{lang} not found)"
      end
      config = config['locale']

      # Set param when `string` is set
      param = nil
      unless string.nil?
        param = input
        input = string
      end

      begin
        if input.nil?
          "(nil)"
        elsif input.class == Time
          if config[lang].has_key? 'date'
            input.strftime(config[lang]['date'])
          else
            "(`date` is not defined for #{lang})"
          end
        elsif input.class == String
          if config[lang].has_key? input
            if param.nil?
              config[lang][input]
            else
              config[lang][input].gsub('$0', param)
            end
          elsif default.nil?
            "(UNKNOWN TEXT: #{input} for #{lang})"
          else
            if param.nil?
              default
            else
              default.gsub('$0', param)
            end
          end
        else
          "(UNKNOWN CLASS: #{input.class})"
        end
      rescue => e
        "(ERROR: #{input} for #{lang} #{e.message})"
      end
    end
  end
end