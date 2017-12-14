class ArticlesController < ApplicationController
  before_action :data_check, :build_request

  ROUTE_MAP = {
    show: proc { |params| Parliament::Utils::Helpers::ParliamentHelper.parliament_request.webarticle_by_id.set_url_params({ webarticle_id: params[:article_id] }) },
  }.freeze

  def show
    @articles, @topics, @audiences = Parliament::Utils::Helpers::RequestHelper.filter_response_data(
      @request,
      Parliament::Utils::Helpers::RequestHelper.namespace_uri_schema_path('Article'),
      'http://example.com/content/Topic',
      'http://example.com/content/Audience',
    )

    # @article = @article.first
    # @others = @others.group_by { |node| node.type }

    # @article_types = @others['http://example.com/content/ArticleType']
    # @audiences = @others['http://example.com/content/Audience']
    # @publishers = @others['http://example.com/content/Publisher']
    # @collections = @others['http://example.com/content/Collection']

  end

end
