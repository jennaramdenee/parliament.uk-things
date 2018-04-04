class ArticlesController < ApplicationController
  before_action :data_check, :build_request, :disable_top_navigation

  ROUTE_MAP = {
    show: proc { |params| Parliament::Utils::Helpers::ParliamentHelper.parliament_request.webarticle_by_id.set_url_params({ webarticle_id: params[:article_id] }) }
  }.freeze

  def show
    articles = Parliament::Utils::Helpers::FilterHelper.filter(@request, 'WebArticle')

    # Finds the article we are looking for, as GET request may return multiple Articles
    @article = articles.find { |article| article.graph_id == params[:article_id] }
    raise ActionController::RoutingError, 'Article Not Found' unless @article

    # Collections an Article belongs to
    @collections = @article.collections

    # For each collection an Article belongs to, find a list of root collections
    @root_collections = []

    # GET request for each of those Collections
    request = Parliament::Utils::Helpers::ParliamentHelper.parliament_request.collection_by_id.set_url_params({ collection_id: collection.graph_id })

    @collections.each do |collection|
      collections = Parliament::Utils::Helpers::RequestHelper.filter_response_data(
        request,
        'http://example.com/content/schema/Collection'
      )

      current_collection = collections.find { |potential_collection| potential_collection.graph_id == collection.graph_id }
      raise ActionController::RoutingError, 'Collection Not Found' unless current_collection

      # Take the current collection's root collections (root collections are last in the collection tree)
      @root_collections << current_collection.collections_paths.map(&:last)
    end

  end
end
