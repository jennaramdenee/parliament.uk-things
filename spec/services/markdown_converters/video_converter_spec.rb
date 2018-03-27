require_relative '../../rails_helper'

RSpec.describe MarkdownConverter::VideoConverter do
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
    it 'replaces video links with HTML' do
      expect(MarkdownConverter::VideoConverter.convert(original_article.article_body)).to eq(converted_article.article_body)
    end
  end

  context '#extract_video_links' do
    it 'can extract video links' do
      expect(MarkdownConverter::VideoConverter.send(:extract_video_links, original_article.article_body)).to eq([["[video id:114c33a1-f412-44a8-b5c1-f1822b895f46 start:06:50:00 end:07:00:00]", "114c33a1-f412-44a8-b5c1-f1822b895f46", "06:50:00", "07:00:00"]])
    end
  end

  context '#create_video_html' do
    it 'can convert a video link to HTML' do
      expect(MarkdownConverter::VideoConverter.send(:create_video_html, '114c33a1-f412-44a8-b5c1-f1822b895f46', '15:00:00', '16:30:00')).to eq("<iframe src='https://videoplayback.parliamentlive.tv/Player/Index/114c33a1-f412-44a8-b5c1-f1822b895f46?in=1900-01-01T15%3A00%3A00%2B01%3A00&amp;out=1900-01-01T16%3A30%3A002B01%3A00&amp;audioOnly=False&amp;autoStart=False&amp;statsEnabled=False' id='UKPPlayer' name='UKPPlayer' title='UK Parliament Player' seamless='seamless' frameborder='0' allowfullscreen style='width:100%;height:100%;'></iframe>")
    end
  end

  context '#encode_video_times' do
    it 'can encode video times' do
      expect(MarkdownConverter::VideoConverter.send(:encode_video_times, '15:00:00')).to eq('15%3A00%3A00')
    end
  end

end
