require 'rails_helper'

RSpec.describe 'articles/show', vcr: true do
  let!(:article) {
    assign(:article,
      double(:article,
        title:           article_title_text,
        article_summary: '## This is a test summary.',
        article_body:    article_body_text,
        graph_id:        article_graph_id
      )
    )
  }

  let!(:subcollection) {
    assign(:subcollection,
      double(:subcollection,
        name:     subcollection_name_text,
        graph_id: 'asdf1234',
      )
    )
  }

  let!(:collections) {
    assign(:collections,
      [
        double(:collections,
          name:           collection_name_text,
          description:    '**This** is a test description of a Collection.',
          graph_id:       'h93dvh57',
          subcollections: [subcollection],
          articles:       [
            double(:article,
              article_title:           article_title_text,
              graph_id:        article_graph_id
            ),
            double(:article2,
              article_title:    collection_article_title_text,
              graph_id:         'gj7e0ikd'
            )
          ]
        )
      ]
    )
  }

  let!(:root_collections) {
    assign(:root_collections, [])
  }

  let!(:article_graph_id)              { 'a3d21x98' }
  let!(:article_title_text)            { 'This is a test Title.' }
  let!(:article_body_text)             { '__This__ is an article body' }
  let!(:collection_name_text)          { 'This is a test Collection.' }
  let!(:collection_article_title_text) { 'Another article title' }
  let!(:subcollection_name_text)       { 'Test Subcollection' }
  let!(:parent_collection_name_text)   { 'Test Parent Collection' }

  before(:each) do
    render
  end

  context 'article' do
    context 'converted to HTML' do
      it 'will render the article title correctly' do
        expect(rendered).to match(/<h1>This is a test Title.<\/h1>/)
      end

      it 'will render the article summary correctly' do
        expect(rendered).to match(/<h2>This is a test summary.<\/h2>/)
      end

      it 'will render the article body correctly' do
        expect(rendered).to match(/<p><strong>This<\/strong> is an article body<\/p>/)
      end
    end

    context 'sanitize' do
      let!(:article_title_text) { '<script>This is a test Title.</script>' }
      let!(:article_body_text)  { '<script>__This__ is an article body</script>' }

      it 'will render the sanitized article title correctly' do
        expect(rendered).to match(/<h1>This is a test Title.<\/h1>/)
      end

      it 'will render the sanitized article summary correctly' do
        expect(rendered).to match(/<h2>This is a test summary.<\/h2>/)
      end

      it 'will render the sanitized article body correctly' do
        expect(rendered).to match(/<p><strong>This<\/strong> is an article body<\/p>/)
      end
    end
  end

  context 'collections' do
    context 'when they exist' do
      context 'converted to HTML' do
        it 'will render a link to collections that article belongs to' do
          expect(rendered).to match(/<a href="\/collections\/h93dvh57">This is a test Collection.<\/a>/)
        end
      end

      context 'sanitize' do
        let!(:collection_name_text)          { '<script>This is a test Collection.</script>' }
        let!(:collection_article_title_text) { '<script>Another article title</script>' }

        it 'will render the sanitized link to collections correctly' do
          expect(rendered).to match(/<a href="\/collections\/h93dvh57">This is a test Collection.<\/a>/)
        end
      end

      context 'rendered as a list of links' do
        it "will render 'up to' text" do
          expect(rendered).to match(/In:/)
        end
      end
    end

    context 'when they do not exist' do
      let!(:collections) {
        assign(:collections, [])
      }

      it "will not render 'up to' text" do
        expect(rendered).not_to match(/In:/)
      end
    end
  end

  context 'collection articles' do
    context 'converted to HTML' do
      it 'will render a link to each article in that collection' do
        expect(rendered).to match(/<a href="\/articles\/gj7e0ikd">Another article title<\/a>/)
      end

      it 'will not render a link to the active article in that collection' do
        expect(rendered).to_not match(/<a href="\/articles\/a3d21x98">This is a test Title.<\/a>/)
      end

      it 'will use an active class for the list item containing the active article title' do
        expect(rendered).to have_css("li.active .list--details", text: article_title_text)
      end
    end

    context 'sanitize' do
      let!(:collection_article_title_text) { '<script>Another article title</script>' }
      it 'will render the sanitized link to each article in that collection' do
        expect(rendered).to match(/<a href="\/articles\/gj7e0ikd">Another article title<\/a>/)
      end
    end
  end

  context 'collection subcollections' do
    context 'converted to HTML' do
      it 'will render a link to each subcollection in that collection' do
        expect(rendered).to match(/<a href="\/collections\/asdf1234">Test Subcollection<\/a>/)
      end
    end

    context 'sanitize' do
      let!(:subcollection_name_text) { '<script>Test Subcollection</script>' }
      it 'will render the sanitized link to each subcollection in that collection' do
        expect(rendered).to match(/<a href="\/collections\/asdf1234">Test Subcollection<\/a>/)
      end
    end
  end

  context 'partials' do
    context 'when collections exist and root collections do not exist' do
      it 'will render the collections/delimited_links partial' do
        expect(response).to render_template(partial: 'collections/_delimited_links')
      end
    end

    context 'when collections do not exist and root collections do not exist' do
      let!(:collections) {
        assign(:collections, [])
      }

      it 'will not render the collections/delimited_links partial' do
        expect(response).not_to render_template(partial: 'collections/_delimited_links')
      end
    end

    context 'when collections do not exist and root collections do' do
      let!(:collections) {
        assign(:collections, [])
      }

      let!(:root_collections) {
        assign(:root_collections, [subcollection])
      }

      it 'will render the collections/delimited_links partial' do
        expect(response).to render_template(partial: 'collections/_delimited_links')
      end
    end
  end

  context 'footer' do
    context 'when collections exist' do
      it "will render 'up to' text" do
        expect(rendered).to match(/Up to/)
      end
    end

    context 'when collections do not exist' do
      let!(:collections) {
        assign(:collections, [])
      }
      it "will not render 'up to' text" do
        expect(rendered).not_to match(/Up to/)
      end
    end
  end
end
