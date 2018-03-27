require_relative '../rails_helper'

RSpec.describe MarkdownConverter do
  let!(:original_article) {
    double(:original_article,
      article_body: File.read("#{Rails.root}/spec/fixtures/markdown/original_markdown_body.txt")
    )
  }

  let!(:converted_article) {
    double(:converted_article,
      article_body: File.read("#{Rails.root}/spec/fixtures/markdown/converted_markdown_body.txt")
    )
  }

  context '#convert' do
    it 'converts markdown' do
      expect(MarkdownConverter.convert(original_article.article_body)).to eq(converted_article.article_body)
    end
  end
end
