class WorkPackagesController < ApplicationController
  before_action :data_check, :build_request

  ROUTE_MAP = {
    show: proc { |params| Parliament::Utils::Helpers::ParliamentHelper.parliament_request.work_package_by_id.set_url_params({ work_package_id: params[:work_package_id] }) }
  }.freeze

  # @return [Grom::Node] object with type 'https://id.parliament.uk/schema/WorkPackageableThing'.
  # NB. work_package_id here represents the graph_id of a WorkPackageableThing Grom::Node
  def show
    @work_packageable_thing, @work_package, @procedure, @business_items, @laying_business_item = Parliament::Utils::Helpers::FilterHelper.filter(
      @request,
      'WorkPackageableThing',
      'WorkPackage',
      'Procedure',
      'BusinessItem'
    )

    @work_packageable_thing = @work_packageable_thing.first
    @work_package = @work_package.first
    @procedure = @procedure.first

    @laying_business_item = @work_packageable_thing.laying_business_item

    # Group business items by their date
    grouped_business_items = BusinessItemGroupingHelper.group(@business_items, :date)

    @completed_business_items, @scheduled_business_items, @business_items_with_no_date = BusinessItemHelper.arrange_by_date(grouped_business_items)
  end
end
