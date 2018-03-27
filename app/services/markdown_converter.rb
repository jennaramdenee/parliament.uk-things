require_relative './markdown_converters/video_converter'

module MarkdownConverter
  def self.convert(markdown)
    MarkdownConverter::VideoConverter.convert(markdown)
  end
end
