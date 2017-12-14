require 'rails_helper'

RSpec.describe ArticlesController, vcr: true do

  describe 'GET show' do
    context 'variable assignment' do
      before(:each) do
        get :show, params: { article_id: 'asdf1234' }
      end

      it 'should have a response with a http status ok (200)' do
        expect(response).to have_http_status(:ok)
      end

      it 'assigns @article as a Grom::Node' do
        expect(assigns(:article)).to be_a(Grom::Node)
      end

      it 'assigns @article as a Grom::Node of type Article' do
        expect(assigns(:article).type).to eq('https://id.parliament.uk/schema/Article')
      end
    end
  end

  describe '#data_check' do
    context 'an available data format is requested' do
      METHODS = [
        {
          route: 'show',
          parameters: { article_id: 'asdf1234' },
          data_url: "#{ENV['PARLIAMENT_BASE_URL']}/webarticle_by_id?webarticle_id=asdf1234"
        }
      ]

      before(:each) do
        headers = { 'Accept' => 'application/rdf+xml' }
        request.headers.merge(headers)
      end

      it 'should have a response with http status redirect (302)' do
        METHODS.each do |method|
          if method.include?(:parameters)
            get method[:route].to_sym, params: method[:parameters]
          else
            get method[:route].to_sym
          end
          expect(response).to have_http_status(302)
        end
      end

      it 'redirects to the data service' do
        METHODS.each do |method|
          if method.include?(:parameters)
            get method[:route].to_sym, params: method[:parameters]
          else
            get method[:route].to_sym
          end
          expect(response).to redirect_to(method[:data_url])
        end
      end

    end

    context 'an unavailable data format is requested' do
      before(:each) do
        headers = { 'Accept' => 'application/foo' }
        request.headers.merge(headers)
      end

      it 'should raise ActionController::UnknownFormat error' do
        expect{ get :show, params: { article_id: 'asdf1234' } }.to raise_error(ActionController::UnknownFormat)
      end
    end
  end



end
