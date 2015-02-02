module ApplicationHelper
  def markdown(text)
    markdown = Redcarpet::Markdown.new(Redcarpet::Render::HTML, autolink: true, tables: true, hard_wrap: true, filter_html: true, no_intraemphasis: true)
    markdown.render(text).html_safe
  end
end
