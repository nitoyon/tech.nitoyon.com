module Jekyll
  module Filters
    # Convert a text using locale file.
    #
    # input - locale.
    # name - key
    #
    # Liquid:
    #     {{'hello' | t}}
    #
    # Locale file(_locale/en.yml):
    #     hello: "Hello world"
    #
    # Returns the translated String.
    def t(input)
      lang = 'en'
      lang = @context['page']['lang'] if @context['page'].has_key?('lang')
      locale_dir = File.join(@context.registers[:site].source, '_locales')
      locale_file = "#{locale_dir}/#{lang}.yml"

      begin
        content = File.read(locale_file)
        yaml = YAML.load(content)
        if yaml.has_key?(input)
          yaml[input] 
        else
          "(UNKNOWN TEXT: #{input} for #{lang})"
        end
      rescue => e
        "(ERROR: #{input} for #{lang} #{e.message})"
      end
    end
  end
end