module WrappersHelper
  class << self
    include Rails.application.routes.url_helpers
    include ActionView::Helpers::UrlHelper
  end

  # Creates a string of delimited links to given collections
  #
  # @param array [Array] Array of collections
  # @param delimiter [String] Delimiter to go between links
  # @return wrapper_template [String] Template as HTML
  def self.render(array, delimiter = ", ")

    template = ""

    array.each_with_index do |item, index|
      template += link_to(item.name, collection_path(item.graph_id))
      template += delimiter if index != (array.size - 1)
    end

    template.html_safe

  end
end
