module ArticleHelper

  WPM = 275.freeze

  def self.read_time(text)
    number_of_words = text.split(" ").length
    (number_of_words/WPM.to_f).ceil
  end

end
