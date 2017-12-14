class ArticlesController < ApplicationController
  before_action :data_check, :build_request

  helper_method :markdown

  ROUTE_MAP = {
    show: proc { |params| Parliament::Utils::Helpers::ParliamentHelper.parliament_request.article_by_id.set_url_params({ article_id: params[:article_id] }) },
  }.freeze

  def show
    @article = Parliament::Utils::Helpers::RequestHelper.filter_response_data(
      @request,
      Parliament::Utils::Helpers::RequestHelper.namespace_uri_schema_path('Article')
    ).first
  end

  def markdown(template)
    markdown = Redcarpet::Markdown.new(Redcarpet::Render::HTML)
    return markdown.render(template).html_safe
  end

end
