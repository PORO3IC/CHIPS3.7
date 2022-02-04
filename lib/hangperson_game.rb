class HangpersonGame

  
  def initialize(word)
    @word = word
    @guesses = ''
    @wrong_guesses = ''
    @word_with_guesses = word.gsub(/./, '-')
    @check_win_or_lose = :play
  end

  attr_accessor :word, :guesses, :wrong_guesses, :word_with_guesses, :check_win_or_lose
  
  def guess(ltr)
    raise ArgumentError if ltr.nil? || ltr.empty? || ltr.index(/[[:alpha:]]/) == nil
    ltr.downcase!
    if @word.downcase.include?(ltr)
      return false if @guesses.include?(ltr)
      @guesses << ltr
      for i in 0...@word.length do
        @word_with_guesses[i] = @word[i] if @word[i].downcase == ltr[0]
      end
      @check_win_or_lose = :win if not @word_with_guesses.include?('-')
    else
      return false if @wrong_guesses.include?(ltr)
      @wrong_guesses << ltr
      @check_win_or_lose = :lose if @wrong_guesses.length >= 7
    end
    true
  end
  
  def self.get_random_word
    require 'uri'
    require 'net/http'
    uri = URI('http://watchout4snakes.com/Random/RandomWord')
    Net::HTTP.post_form(uri ,{}).body
  end

end
