# Namespace for ProcedureStep Item Grom::Node helper methods
module ProcedureStepHelper
  # Sort procedure steps first by distance, and then by business item date, putting those with nil at the end
  #
  # @param data [Array] Array of Grom::Nodes to be sorted
  # @return Array of sorted Business Item Grom::Nodes
  def self.arrange_by_distance_and_date(procedure_steps)
    grouped_procedure_steps = group_by_distance(procedure_steps)
    sorted_distances = sorted_distances(grouped_procedure_steps)
    create_sorted_array(sorted_distances, grouped_procedure_steps)
  end

  private

  # Group an array of Grom::Nodes by their distance
  #
  # @param data [Array] Array of Grom::Nodes to be grouped
  # @return Hash, with distance as keys, and array of Grom::Nodes with that distance as value
  def self.group_by_distance(data)
    data.group_by { |node| node.distance_from_origin }
  end

  # Sort available distances in incremental order
  #
  # @param data_hash [Hash] Hash, with distance as keys, and array of Grom::Nodes with that distance as value
  # @return Array of sorted distances
  def self.sorted_distances(data_hash)
    data_hash.keys.sort
  end

  # Sort procedure steps by business item date, putting those with nil at the end
  #
  # @param data [Array] Array of Grom::Nodes to be sorted
  # @return Array of sorted ProcedureStep Grom::Nodes
  def self.sort_by_business_item_date(nodes)
    Parliament::NTriple::Utils.sort_by({
      list: nodes,
      parameters: [:business_item_date],
      prepend_rejected: false
    })
  end

  # Using an array of sorted distances, find nodes for each distance, sort by date and add to a new array
  #
  # @param distances [Array] Array of distances
  # @param data_hash [Hash] Hash, with distance as keys, and array of Grom::Nodes with that distance as value
  # @return Array of sorted ProcedureStep Grom::Nodes
  def self.create_sorted_array(distances, data_hash)
    sorted_procedure_steps = []
    distances.each do |key|
      sorted_procedure_steps << sort_by_business_item_date(data_hash[key])
    end

    sorted_procedure_steps.flatten
  end
end



#
