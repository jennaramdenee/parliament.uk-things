require_relative './markdown_converters/video_converter'

class MarkdownConverter
  def self.convert(markdown)
    MarkdownConverter::VideoConverter.convert(markdown)
  end
end
