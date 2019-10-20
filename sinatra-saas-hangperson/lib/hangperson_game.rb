class HangpersonGame

  # add the necessary class methods, attributes, etc. here
  # to make the tests in spec/hangperson_game_spec.rb pass.

  # Get a word from remote "random word" service

  attr_accessor :word
  attr_accessor :guesses
  attr_accessor :wrong_guesses


  def initialize(word)
    @word = word.downcase
    @guesses = ''
    @wrong_guesses = ''
  end

  # You can test it by running $ bundle exec irb -I. -r app.rb
  # And then in the irb: irb(main):001:0> HangpersonGame.get_random_word
  #  => "cooking"   <-- some random word
  def self.get_random_word
    require 'uri'
    require 'net/http'
    uri = URI('http://watchout4snakes.com/wo4snakes/Random/RandomWord')
    Net::HTTP.new('watchout4snakes.com').start { |http|
      return http.post(uri, "").body
    }
  end

  def guess(guess)
      invalid(guess)
      use = guess.downcase
      correct = false
      if @guesses.include? use or @wrong_guesses.include? use
        return false
      end
      for i in 0...(@word.length)
          if @word[i] == use
            correct = true
          end
      end
      if !correct
        @wrong_guesses += use
      else
        @guesses += use
      end
    
  end

  def word_with_guesses()
    save = ''
    for i in 0...(@word.length) do
      letter = @word[i]
      if @guesses.include? letter
        save += letter
      else
        save += '-'
      end
    end
    return save
  end

  def invalid(word)
    if (word == '') or (word == nil) or !(word =~ /[a-zA-z]/)
      raise ArgumentError
    end
  end

  def check_win_or_lose()
    if @wrong_guesses.length >= 7
      return :lose 
    elsif word_with_guesses == @word
      return :win
    else
      :play
    end
  end



end
