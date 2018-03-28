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
    context 'with start and end times' do
      it 'can extract video links' do
        expect(MarkdownConverter::VideoConverter.send(:extract_video_links, original_article.article_body)).to include(
          [
            "https://parliamentlive.tv/event/index/1b5736b4-7c93-4827-a02f-abbf0bb36cc8?in=12:00:00&out=13:00:00",
            "1b5736b4-7c93-4827-a02f-abbf0bb36cc8",
            "?in=12:00:00&out=13:00:00",
            "12:00:00",
            "13:00:00"
          ]
        )
      end
    end

    context 'with no start or end times' do
      it 'can extract video links' do
        expect(MarkdownConverter::VideoConverter.send(:extract_video_links, original_article.article_body)).to include(
          [
            "https://parliamentlive.tv/event/index/bf2334ce-e87f-4224-9a81-9a0e9886f19b",
            "bf2334ce-e87f-4224-9a81-9a0e9886f19b",
            nil,
            nil,
            nil
          ]
        )
      end
    end
  end

  context '#create_video_html' do
    context 'with start and end time' do
      it 'can convert a video link to HTML' do
        expect(MarkdownConverter::VideoConverter.send(:create_video_html, '114c33a1-f412-44a8-b5c1-f1822b895f46', '15:00:00', '16:30:00')).to eq("<iframe src='https://videoplayback.parliamentlive.tv/Player/Index/114c33a1-f412-44a8-b5c1-f1822b895f46?in=1900-01-01T15%3A00%3A00%2B00%3A00&amp;out=1900-01-01T16%3A30%3A00%2B00%3A00&amp;audioOnly=False&amp;autoStart=False&amp;statsEnabled=False' id='UKPPlayer' name='UKPPlayer' title='UK Parliament Player' seamless='seamless' frameborder='0' allowfullscreen style='width:100%;height:100%;'></iframe>")
      end
    end

    context 'with no start or end time' do
      it 'can convert a video link to HMTL' do
        expect(MarkdownConverter::VideoConverter.send(:create_video_html, '114c33a1-f412-44a8-b5c1-f1822b895f46')).to eq("<iframe src='https://videoplayback.parliamentlive.tv/Player/Index/114c33a1-f412-44a8-b5c1-f1822b895f46?audioOnly=False&amp;autoStart=False&amp;statsEnabled=False' id='UKPPlayer' name='UKPPlayer' title='UK Parliament Player' seamless='seamless' frameborder='0' allowfullscreen style='width:100%;height:100%;'></iframe>")
      end
    end
  end

  context '#encode_video_times' do
    it 'can encode video times' do
      expect(MarkdownConverter::VideoConverter.send(:encode_video_times, '15:00:00')).to eq('15%3A00%3A00')
    end
  end

end
