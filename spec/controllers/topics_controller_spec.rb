require 'rails_helper'

RSpec.describe TopicsController, vcr: true do
  describe 'GET show' do
    context 'variable assignment' do
      context 'when successful' do
        before(:each) do
          get :show, params: { topic_id: 'yDYJSViV' }
        end
        it 'should have a response with a http status ok (200)' do
          expect(response).to have_http_status(:ok)
        end

        it 'assigns @topic as a Grom::Node' do
          expect(assigns(:topic)).to be_a(Grom::Node)
        end

        it 'assigns @topic as a Grom::Node of type Article' do
          expect(assigns(:topic).type).to eq('https://id.parliament.uk/schema/Concept')
        end

        it 'assigns @topic to the article with correct id' do
          expect(assigns(:topic).graph_id).to eq('yDYJSViV')
        end
      end

      context 'when unsuccessful' do
        it 'should raise ActionController::RoutingError error' do
          expect { get :show, params: { topic_id: 'asdf1234' } }.to raise_error(ActionController::RoutingError, 'Topic Not Found')
        end
      end
    end
  end

  describe '#data_check' do
    let(:data_check_methods) do
      [
        {
          route: 'show',
          parameters: { topic_id: 'yDYJSViV' },
          data_url: "#{ENV['PARLIAMENT_BASE_URL']}/concept_by_id?concept_id=yDYJSViV"
        }
      ]
    end

    it_behaves_like 'a data service request'

    context 'an unavailable data format is requested' do
      before(:each) do
        headers = { 'Accept' => 'application/foo' }
        request.headers.merge(headers)
      end
      it 'should raise ActionController::UnknownFormat error' do
        expect{ get :show, params: { topic_id: 'yDYJSViV' } }.to raise_error(ActionController::UnknownFormat)
      end
    end
  end
end
