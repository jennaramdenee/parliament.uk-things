require 'cgi'

module MarkdownConverter
  class VideoConverter
    class << self
      def convert(markdown)
        video_links_array = extract_video_links(markdown)
        video_links_array.each do |video_link|
          original_video_link = video_link[0]
          id = video_link[1]
          start_time = video_link[3]
          end_time = video_link[4]

          converted_video_html = create_video_html(id, start_time, end_time)
          markdown.gsub!(original_video_link, converted_video_html)
        end
        markdown
      end

      private

      def extract_video_links(markdown)
        # regex = Regexp.union(/(\[video id:(\S{36})\])/, /start:(\S+) end:(\S+)/)
        # markdown.scan(regex)
        # markdown.scan(/(\[video id:(\S{36}) start:(\S+) end:(\S+)\])/)
        markdown.scan(/(\[video id:(\S{36})( start:(\S+) end:(\S+))?\])/)

      end

      def create_video_html(id, start_time = nil, end_time = nil)
        video_html_string = "<iframe src='https://videoplayback.parliamentlive.tv/Player/Index/#{id}?"
        video_html_string += "in=1900-01-01T#{encode_video_times(start_time)}%2B01%3A00&amp;out=1900-01-01T#{encode_video_times(end_time)}2B01%3A00&amp;" if start_time && end_time
        video_html_string += "audioOnly=False&amp;autoStart=False&amp;statsEnabled=False' id='UKPPlayer' name='UKPPlayer' title='UK Parliament Player' seamless='seamless' frameborder='0' allowfullscreen style='width:100%;height:100%;'></iframe>"
      end

      def encode_video_times(time)
        CGI.escape(time)
      end
    end
  end
end


# (\[video id:(\S{36}) start:(\S+) end:(\S+)\]) | (\[video id:(\S{36})\])
