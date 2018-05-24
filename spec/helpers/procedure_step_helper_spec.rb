require_relative '../rails_helper'

RSpec.describe ProcedureStepHelper do
  let(:node1) { double('node1', :distance_from_origin => 0, :business_item_date => DateTime.new(2018, 06, 04)) }
  let(:node2) { double('node2', :distance_from_origin => 0, :business_item_date => DateTime.new(2017, 12, 23)) }
  let(:node3) { double('node3', :distance_from_origin => 2, :business_item_date => DateTime.new(2018, 04, 20)) }
  let(:node4) { double('node4', :distance_from_origin => 1, :business_item_date => DateTime.new(2017, 12, 23)) }
  let(:node5) { double('node5', :distance_from_origin => 0, :business_item_date => nil) }
  let(:data)  {[node1, node2, node3, node4, node5]}
  let(:data_hash) {
    {
      0 => [ node1, node2, node5 ],
      1 => [ node4 ],
      2 => [ node3 ]
    }
  }

  describe '#arrange_by_distance_and_date' do
    # let(:node1) { double('node1', :distance_from_origin => 0, :business_item_date => DateTime.new(2018, 06, 04)) }
    # let(:node2) { double('node2', :distance_from_origin => 0, :business_item_date => DateTime.new(2017, 12, 23)) }
    # let(:node3) { double('node3', :distance_from_origin => 2, :business_item_date => DateTime.new(2018, 04, 20)) }
    # let(:node4) { double('node4', :distance_from_origin => 1, :business_item_date => DateTime.new(2017, 12, 23)) }
    # let(:node5) { double('node5', :distance_from_origin => 0, :business_item_date => nil) }
    # let(:data)  {[node1, node2, node3, node4, node5]}

    context 'with no data' do
      it 'returns an empty array' do
        expect(ProcedureStepHelper.arrange_by_distance_and_date([])).to eq([])
      end
    end

    context 'with data' do
      it 'returns an array of distance and date ordered nodes' do
        expect(ProcedureStepHelper.arrange_by_distance_and_date(data)).to eq([node2, node1, node5, node4, node3])
      end
    end
  end

  describe '#group_by_distance' do
    context 'with no data' do
      it 'returns an empty array' do
        expect(ProcedureStepHelper.send(:group_by_distance, [])).to eq({})
      end
    end

    context 'with data' do
      it 'returns a grouped hash' do
        expect(ProcedureStepHelper.send(:group_by_distance, data)).to eq(data_hash)
      end
    end
  end

  describe '#sorted_distances' do
    context 'with no data' do
      it 'returns an empty array' do
        expect(ProcedureStepHelper.send(:sorted_distances, {})).to eq([])
      end
    end

    context 'with data' do
      it 'returns an array with sorted distances' do
        expect(ProcedureStepHelper.send(:sorted_distances, data_hash)).to eq([0, 1, 2])
      end
    end
  end

  describe '#sort_by_business_item_date' do
    context 'with no data' do
      it 'returns an empty array' do
        expect(ProcedureStepHelper.send(:sort_by_business_item_date, [])).to eq([])
      end
    end

    context 'with data' do
      it 'returns an array sorted by business item date' do
        expect(ProcedureStepHelper.send(:sort_by_business_item_date, data)).to eq([node2, node4, node3, node1, node5])
      end
    end
  end

  describe '#create_sorted_array' do
    context 'with no data' do
      it 'returns an empty array' do
        expect(ProcedureStepHelper.send(:create_sorted_array, [], {})).to eq([])
      end
    end

    context 'with data' do
      it 'returns an array sorted by business item date' do
        distances = [0, 1, 2]
        expect(ProcedureStepHelper.send(:create_sorted_array, distances, data_hash)).to eq([node2, node1, node5, node4, node3])
      end
    end
  end
end
