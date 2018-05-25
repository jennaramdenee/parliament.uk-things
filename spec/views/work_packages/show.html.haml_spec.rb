require 'rails_helper'

RSpec.describe 'work_packages/show', vcr: true do
  let!(:work_packageable_thing) {
    assign(:work_packageable_thing,
      double(:work_packageable_thing,
        name:'Test work package name',
        weblink: 'www.legislation.gov/test-memorandum',
      )
    )
  }

  let!(:procedure) {
    assign(:procedure,
      double(:procedure,
        name: 'Draft affirmative',
        graph_id: 't4fvh8mn'
      )
    )
  }

  let!(:ordered_procedure_steps) {
    assign(:ordered_procedure_steps, [])
  }

  let!(:possible_procedure_steps) {
    assign(:possible_procedure_steps, [])
  }

  let!(:procedure_step) {
    assign(:procedure_step,
      double(:procedure_step,
        name: 'Procedure step name 1',
        houses: [
          double(:house, name: 'House of Commons')
        ],
        business_item: business_item
      )
    )
  }

  let!(:business_item){
    assign(:business_item,
      double(:business_item,
        class: 'https://id.parliament.uk/BusinessItem',
        date: DateTime.new(2018,05,30),
        weblink: 'www.test2.com',
        sorted_procedure_steps_by_distance: [
          double(:procedure_step,
            name: 'Procedure step name 2',
            houses: [
              double(:house, name: 'House of Lords'),
              double(:house, name: 'House of Commons')
            ]
          )
        ]
      )
    )
  }

  before(:each) do
    render
  end

  context 'work package details' do
    it 'displays name' do
      expect(rendered).to match(/Test work package name/)
    end
  end

  context 'about' do
    it 'displays procedure name' do
      expect(rendered).to match(/draft affirmative/)
    end

    it 'displays web link' do
      expect(rendered).to match(/<a href="www.legislation.gov\/test-memorandum">/)
    end
  end

  context 'ordered steps' do
    context 'when they exist' do
      let!(:ordered_procedure_steps) {
        assign(:ordered_procedure_steps, [procedure_step])
      }

      it 'will render heading' do
        expect(response).to match(/Ordered steps/)
      end

      it 'will render step name' do
        expect(response).to match(/Procedure step name 1/)
      end

      it 'will render step houses' do
        expect(response).to match(/House of Commons/)
      end

      context 'with a business item date' do
        it 'will render date' do
          expect(response).to match(DateTime.new(2018,05,30))
        end
      end

      context 'with no business item date' do
        let!(:business_item){
          assign(:business_item,
            double(:business_item,
              class: 'https://id.parliament.uk/BusinessItem',
              date: nil,
              weblink: 'www.test2.com',
              sorted_procedure_steps_by_distance: [
                double(:procedure_step,
                  name: 'Procedure step name 2',
                  houses: [
                    double(:house, name: 'House of Lords'),
                    double(:house, name: 'House of Commons')
                  ]
                )
              ]
            )
          )
        }
        it 'will not render date' do
          expect(response).not_to match(/3 Mar 2018/)
        end
      end
    end

    context 'when they do not exist' do
      it 'will not render heading' do
        expect(response).not_to match(/Ordered steps/)
      end

      it 'will not render step name' do
        expect(response).not_to match(/Procedure step name 1/)
      end

      it 'will not render step houses' do
        expect(response).not_to match(/House of Commons/)
      end

      it 'will not render date' do
        expect(response).not_to match(/3 Mar 2018/)
      end
    end
  end

  context 'possible steps' do
    context 'when they exist' do
      let!(:possible_procedure_steps) {
        assign(:possible_procedure_steps, [procedure_step])
      }

      it 'will render heading' do
        expect(response).to match(/Possible steps/)
      end

      it 'will render step name' do
        expect(response).to match(/Procedure step name 1/)
      end
    end

    context 'when they do not exist' do
      it 'will not render heading' do
        expect(response).not_to match(/Possible steps/)
      end

      it 'will not render step name' do
        expect(response).not_to match(/Procedure step name 1/)
      end
    end
  end
end
