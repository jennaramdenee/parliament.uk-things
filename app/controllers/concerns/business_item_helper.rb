# Namespace for Business Item Grom::Node helper methods
module BusinessItemHelper
  # Split business items into past, future and no date
  #
  # @return Three arrays - business items in the past, in the future and those with no date
  def self.split_by_date(business_items)
    completed_business_items = []
    scheduled_business_items = []

    business_items.each do |business_item|
      # business_items_with_no_date << business_item if business_item.date.nil?
      completed_business_items << business_item if business_item.date.nil? || business_item.date&.past?
      scheduled_business_items << business_item if business_item.date.present? && business_item.date.future?
    end

    return completed_business_items, scheduled_business_items
  end
end
