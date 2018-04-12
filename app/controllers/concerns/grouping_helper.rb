module GroupingHelper
  # Groups objects by category where possible
  #
  # @param data [Array] Array of Grom::Nodes to be grouped
  # @param grouping_methods [Symbol] One or more methods that should be called on Grom::Node to find suitable nodes for grouping
  # @return [Array] Single array of grouped, ungrouped and unknown objects
  def group(data, *grouping_methods)
    grouped_data = group_data(data, grouping_methods)
    create_sorted_array(grouped_data)
  end

  # Where grouping methods can be called (e.g. #category and #id), this method groups by the result of calling each of those methods in succession on each Grom::Node
  # If a grouping cannot be found, adds 'UNKNOWN' as key of the hash
  #
  # @param data [Array] Array of Grom::Nodes to be grouped
  # @param grouping_methods [Array] One or more methods that should be called on Grom::Node to find suitable nodes for grouping
  # @return [Hash] Keys identify grouping (grouped by category.property), with each value being an array of grouped, ungrouped and unknown Grom::Nodes
  #
  # e.g. { 12345678 => [...], 23456789 => [...], "UNKNOWN" => [...] }
  def group_data(data, grouping_methods)
    data.group_by do |data_point|
      grouping_methods.inject(data_point) { |point, method| point.try(method) } || 'UNKNOWN'
    end
  end
end
