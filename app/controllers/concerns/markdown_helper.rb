module MarkdownHelper

  def self.markdown(template)
    markdown = Redcarpet::Markdown.new(Redcarpet::Render::HTML)
    return markdown.render(template).html_safe
  end

end
