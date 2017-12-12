module ArticleHelper

  def self.read_time(text)
    number_of_words = text.split(" ").length
    (number_of_words/275.to_f).ceil
  end

end
