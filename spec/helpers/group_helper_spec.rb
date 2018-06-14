require_relative '../rails_helper'

RSpec.describe GroupHelper do

  let(:node_with_no_attributes) { double(:node) }
  let(:node_with_priority_attribute) {
    double(:node,
      :formalBodyName      => 'Test formal body name',
      :formalBodyStartDate => '2015-06-12+00:00',
      :formalBodyEndDate   => '2018-07-11+00:00'
    )
  }
  let(:node_with_non_priority_attribute) {
    double(:node,
      :groupName      => 'Test group name',
      :groupStartDate => '2017-08-22+00:00',
      :groupEndDate   => '2020-11-11+00:00'
    )
  }

  describe '#assign_attribute' do
    describe 'name' do
      context 'when node has no attributes' do
        it 'returns default' do
          expect(GroupHelper.assign_attribute(node_with_no_attributes, :name, [:formalBody, :group])).to eq('')
        end
      end

      context 'when node has a required priority attribute' do
        it 'returns correct attribute' do
          expect(GroupHelper.assign_attribute(node_with_priority_attribute, :name, [:formalBody, :group])).to eq('Test formal body name')
        end
      end

      context 'when node has a required non priority attribute' do
        it 'returns correct attribute' do
          expect(GroupHelper.assign_attribute(node_with_non_priority_attribute, :name, [:formalBody, :group])).to eq('Test group name')
        end
      end
    end
  end

  describe 'start date' do
    context 'when node has no attributes' do
      it 'returns default' do
        expect(GroupHelper.assign_attribute(node_with_no_attributes, :start_date, [:formalBody, :group])).to eq(nil)
      end
    end

    context 'when node has a required priority attribute' do
      it 'returns correct attribute' do
        expect(GroupHelper.assign_attribute(node_with_priority_attribute, :start_date, [:formalBody, :group]) { |start_date| DateTime.parse(start_date) }).to eq(DateTime.new(2015,6,12))
      end
    end

    context 'when node has a required non priority attribute' do
      it 'returns correct attribute' do
        expect(GroupHelper.assign_attribute(node_with_non_priority_attribute, :start_date, [:formalBody, :group]) { |start_date| DateTime.parse(start_date) }).to eq(DateTime.new(2017,8,22))
      end
    end
  end

  describe 'end date' do
    context 'when node has no attributes' do
      it 'returns default' do
        expect(GroupHelper.assign_attribute(node_with_no_attributes, :end_date, [:formalBody, :group])).to eq(nil)
      end
    end

    context 'when node has a required priority attribute' do
      it 'returns correct attribute' do
        expect(GroupHelper.assign_attribute(node_with_priority_attribute, :end_date, [:formalBody, :group]) { |end_date| DateTime.parse(end_date) }).to eq(DateTime.new(2018,7,11))
      end
    end

    context 'when node has a required non priority attribute' do
      it 'returns correct attribute' do
        expect(GroupHelper.assign_attribute(node_with_non_priority_attribute, :end_date, [:formalBody, :group]) { |end_date| DateTime.parse(end_date) }).to eq(DateTime.new(2020,11,11))
      end
    end
  end
end
