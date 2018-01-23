class TopicsController < ApplicationController
  before_action :data_check, :build_request, :disable_top_navigation

  ROUTE_MAP = {
    show: proc { |params| Parliament::Utils::Helpers::ParliamentHelper.parliament_request.concept_by_id.set_url_params({ concept_id: params[:topic_id] }) }
  }.freeze

  def show
    topics = Parliament::Utils::Helpers::FilterHelper.filter(@request, 'Concept')

    # Finds the topic we are looking for, as GET request may return multiple Topics
    @topic = topics.find { |topic| topic.graph_id == params[:topic_id] }
    raise ActionController::RoutingError, 'Topic Not Found' unless @topic

    # Returns array of Topic Grom::Nodes
    @parent_topics = @topic.parent_topics
    @child_topics = @topic.child_topics
    @topic_articles = @topic.tagged_articles.sort_by(&:article_title)

  end

end
