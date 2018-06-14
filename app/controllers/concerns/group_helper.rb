# Namespace for Group Grom::Node helper methods
module GroupHelper

  ATTRIBUTE_MAPPING = {
    name: {
      group:      'groupName',
      formalBody: 'formalBodyName',
      default:    ''
    },
    start_date: {
      group:      'groupStartDate',
      formalBody: 'formalBodyStartDate',
      default:    nil
    },
    end_date: {
      group:      'groupEndDate',
      formalBody: 'formalBodyEndDate',
      default:    nil
    }
  }

  # Method to return desired attribute of a Grom::Node, according to a defined priority
  # @note Group Grom::Nodes may have many types, and we may want to choose which attribute to use
  # @param node [Grom::Node] the object for which an attribute will be returned
  # @param attribute [Sym] the desired attribute for the node
  # @param priority [Array] an array of Group type, in priority order
  # @param block [Block] an optional code block to execute
  # @example Returning name for a FormalBody Grom::Node (that is also a Group Grom::Node)
  #   attribute_mapper(node, 'name', [:formalBody, :group]) { |start_date| DateTime.parse(start_date) }
  def self.assign_attribute(node, attribute, priority, &block)
    attribute_mapping_hash = ATTRIBUTE_MAPPING[attribute]

    priority.each do |type|
      if node.respond_to?(attribute_mapping_hash[type])
        return node.send(attribute_mapping_hash[type]) if !block_given?
        return block.call(node.send(attribute_mapping_hash[type]))
      end
    end

    attribute_mapping_hash[:default]
  end
end
