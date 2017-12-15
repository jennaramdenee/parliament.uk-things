class ArticlesController < ApplicationController
  before_action :data_check, :build_request

  ROUTE_MAP = {
    show: proc { |params| Parliament::Utils::Helpers::ParliamentHelper.parliament_request.webarticle_by_id.set_url_params({ webarticle_id: params[:article_id] }) },
  }.freeze

  def show
    articles = Parliament::Utils::Helpers::RequestHelper.filter_response_data(
      @request,
      Parliament::Utils::Helpers::RequestHelper.namespace_uri_schema_path('WebArticle')
    )

    # Finds the article we are looking for, as GET request may return multiple Articles
    @article = articles.find { |a| a.graph_id == params[:article_id] }

    raise ActionController::RoutingError, 'Article Not Found' unless @article
  end

end
