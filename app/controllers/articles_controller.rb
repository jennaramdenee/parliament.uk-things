class ArticlesController < ApplicationController
  before_action :data_check, :build_request

  ROUTE_MAP = {
    show: proc { |params| Parliament::Utils::Helpers::ParliamentHelper.parliament_request.article_by_id.set_url_params({ article_id: params[:article_id] }) },
  }.freeze

  def show
    @article = Parliament::Utils::Helpers::RequestHelper.filter_response_data(
      @request,
      Parliament::Utils::Helpers::RequestHelper.namespace_uri_schema_path('Article')
    ).first
<<<<<<< HEAD
=======

    markdown = Redcarpet::Markdown.new(Redcarpet::Render::HTML)

    @article_body = markdown.render(@article.articleBody).html_safe
>>>>>>> c5a27112a93b5a7a24cec55313ba739229b3133d
  end

end
