# Markdown Plugin for Jekyll
# ==========================
#
# Write 'markdown' anyware.
#
# How to use
# ----------
#
# (before)
#
#     <div class="a">
#     <h1>foo</h1>
#     <a href="https://github.com/">GitHub</a>
#     </div>
#
# (after)
#
#     <div class="a">
#     {% markdown %}
#     # foo
#     
#     [GitHub](https://github.com/)
#     {% markdownend %}
#     </div>

module Jekyll
  class MarkdownBlock < Liquid::Block
    def initialize(tag_name, markup, tokens)
      super
    end

    def render(context)
      md = context.registers[:site].converters.find { |c|
        c.class == Jekyll::Converters::Markdown
      }
      if md.nil?
        "ERROR: markdown converter not found"
      else
        md.convert(super)
      end
    end
  end

end

Liquid::Template.register_tag('markdown', Jekyll::MarkdownBlock)
