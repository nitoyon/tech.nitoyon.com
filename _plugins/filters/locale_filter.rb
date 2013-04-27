module Jekyll
  module Filters
    # Convert a text using locale file.
    #
    # input - key name when string is nil, parameter otherwise.
    # string - key name or nil.
    #
    # Locale file(_locales/en.yml):
    #     hello: "Hello world"
    #     hello2: "Hello world '$0'"
    #
    # Liquid:
    #     {{'hello' | t}}            # => Hello world
    #     {{'foo' | t:hello2}}       # => Hello world 'foo'
    #
    # Returns the translated String.
    def t(input, string=nil)
      lang = 'en'
      lang = @context['page']['lang'] if @context['page'].has_key?('lang')
      locale_dir = File.join(@context.registers[:site].source, '_locales')
      locale_file = "#{locale_dir}/#{lang}.yml"

      $locale_filter_mtime = {} if $locale_filter_mtime.nil?
      $locale_filter_hash = {} if $locale_filter_hash.nil?

      # Set param when `string` is set
      param = nil
      unless string.nil?
        param = input
        input = string
      end

      begin
        # reload locale YAML if modified
        if File.mtime(locale_file) > ($locale_filter_mtime[lang] || Time.new(0))
          $locale_filter_hash[lang] = YAML.load(File.read(locale_file))
          $locale_filter_mtime[lang] = File.mtime(locale_file)
          puts "loaded #{locale_file}"
        end

        if input.nil?
          "(nil)"
        elsif input.class == Time
          if $locale_filter_hash[lang].has_key? 'date'
            input.strftime($locale_filter_hash[lang]['date'])
          else
            "(`date` is not defined for #{lang})"
          end
        elsif input.class == String
          if $locale_filter_hash[lang].has_key? input
            ret = $locale_filter_hash[lang][input]
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