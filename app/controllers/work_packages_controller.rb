class WorkPackagesController < ApplicationController
  before_action :data_check, :build_request

  ROUTE_MAP = {
    show: proc { |params| Parliament::Utils::Helpers::ParliamentHelper.parliament_request.work_package_by_id.set_url_params({ work_package_id: params[:work_package_id] }) }
  }.freeze

  # @return [Grom::Node] object with type 'https://id.parliament.uk/schema/WorkPackageableThing'.
  # NB. work_package_id here represents the graph_id of a WorkPackageableThing Grom::Node
  def show
    @work_package, @work_packageable_thing, @procedure, @actualized_procedure_steps, @possible_procedure_steps = Parliament::Utils::Helpers::RequestHelper.filter_response_data(
      @request,
      'https://id.parliament.uk/schema/WorkPackage',
      'https://id.parliament.uk/schema/WorkPackageableThing',
      'https://id.parliament.uk/schema/Procedure',
      'https://example.com/Actualized',
      'https://example.com/Possible'
    )

    @work_package = @work_package.first
    @work_packageable_thing = @work_packageable_thing.first
    @procedure = @procedure.first


    # Order business items by where they appear in the procedure
    # @ordered_business_items = @actualized_procedure_steps.sort_by(:business_item_date, :distance_from_origin, :name).map(&:business_item).uniq
    # @ordered_business_items = @actualized_procedure_steps.sort_by(:distance_from_origin, :business_item_date, :name).map(&:business_item).uniq
    @ordered_business_items = @actualized_procedure_steps.sort_by(:distance_from_origin, :name).map(&:business_item).uniq

    # Group business items by their date
    @grouped_and_ordered_business_items = BusinessItemGroupingHelper.group(@ordered_business_items, :date)
  end
end
