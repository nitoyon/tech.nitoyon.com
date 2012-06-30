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

      $locale_filter_mtime = {} if $locale_filter_mtime.nil?
      $locale_filter_hash = {} if $locale_filter_hash.nil?

      begin
        if File.mtime(locale_file) > ($locale_filter_mtime[lang] || Time.new(0))
          $locale_filter_hash[lang] = YAML.load(File.read(locale_file))
          $locale_filter_mtime[lang] = File.mtime(locale_file)
          puts "loaded #{locale_file}"
        end

        if $locale_filter_hash[lang].has_key? input
          $locale_filter_hash[lang][input]
        else
          "(UNKNOWN TEXT: #{input} for #{lang})"
        end
      rescue => e
        "(ERROR: #{input} for #{lang} #{e.message})"
      end
    end
  end
end