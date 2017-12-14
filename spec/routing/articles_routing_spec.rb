require 'rails_helper'

RSpec.describe 'articles', type: :routing do
  describe 'ArticlesController' do
    context 'show' do
      it 'GET articles#show' do
        expect(get: '/articles/ccdwcKYM').to route_to(
          controller:       'articles',
          action:           'show',
          article_id: 'ccdwcKYM'
        )
      end
    end
  end
end
