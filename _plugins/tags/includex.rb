# Extended Include Plugin for Jekyll
# ==================================
#
# Add parameter function to 'include' plugin.
#
# How to use
# ----------
#
# _includes/foo.html
#     {% for post in ##1## limit:##2## %}{{ post.title }}{% endfor %}
#
# index.html
#     {% includex foo.html,posts,20 %}
#
# result:
#     {% for post in posts limit:20 %}{{ post.title }}{% endfor %}

module Jekyll

  class ExtendedInclude < Liquid::Tag
    def initialize(tag_name, file, tokens)
      super
      params = file.split(",")
      @file = params[0].strip
      @params = params[1..-1]
    end

    def render(context)
      includes_dir = File.join(context.registers[:site].source, '_includes')

      if File.symlink?(includes_dir)
        return "Includes directory '#{includes_dir}' cannot be a symlink"
      end

      if @file !~ /^[a-zA-Z0-9_\/\.-]+$/ || @file =~ /\.\// || @file =~ /\/\./
        return "Include file '#{@file}' contains invalid characters or sequences"
      end

      Dir.chdir(includes_dir) do
        choices = Dir['**/*'].reject { |x| File.symlink?(x) }
        if choices.include?(@file)
          source = File.read(@file).gsub(/##(\d+)##/) {
            puts $1
            if $1.to_i <= @params.length
              @params[$1.to_i - 1]
            else
              "(param #{$1} not found)"
            end
          }
          puts source
          partial = Liquid::Template.parse(source)
          context.stack do
            partial.render(context)
          end
        else
          "Included file '#{@file}' not found in _includes directory"
        end
      end
    end
  end

end

Liquid::Template.register_tag('includex', Jekyll::ExtendedInclude)
