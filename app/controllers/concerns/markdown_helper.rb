module MarkdownHelper

  def self.markdown(template)
    markdown = Redcarpet::Markdown.new(Redcarpet::Render::HTML, tables: true)
    return markdown.render(template).html_safe
  end

end
