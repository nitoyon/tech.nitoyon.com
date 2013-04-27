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
    def self.translate(config, lang, input, string=nil)
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
            ret = config[lang][input]
            ret = ret.gsub('$0', param) unless param.nil?
            ret
          else
            "(UNKNOWN TEXT: #{input} for #{lang})"
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