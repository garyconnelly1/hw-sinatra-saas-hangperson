class HangpersonGame

  # add the necessary class methods, attributes, etc. here
  # to make the tests in spec/hangperson_game_spec.rb pass.

 
  # Initialize the game
  def initialize(word)
    @word = word
    @guesses = ''
    @wrong_guesses = ''
    @word_with_guesses = ''
    word.each_char do |i|
     
      @word_with_guesses << '-'
    end
    @check_win_or_lose = :play

  end

  # Grab a random word from the dictionary
  def self.get_random_word
    require 'uri'
    require 'net/http'
    uri = URI('http://watchout4snakes.com/wo4snakes/Random/RandomWord')
    Net::HTTP.post_form(uri ,{}).body
  end
  
  
  
  def guess(letter)
    
    raise ArgumentError if letter.nil?
    raise ArgumentError if letter == ''
    raise ArgumentError if !letter.match(/[a-zA-Z]/)

    letter.downcase!
    
    if word.include? letter
     if !guesses.include? letter
        guesses << letter ## Add the letter to the guesses array if that letter has not been guessed already.
        for i in 0..word.length ## For each letter in the word including the last letter in the word.
          if word[i] == letter ## If the letter is equal to the letter at i index in word.
            word_with_guesses[i] = letter ## Change the character at that index from '-' to the letter.
            if !word_with_guesses.include? '-' ## If the word with guesses does not include a '-'.
              @check_win_or_lose = :win ## The game has been won.
            end
          end
        end
        return true
      end
    else
       if !wrong_guesses.include? letter ## If the letter has not already been guessed.
        wrong_guesses << letter ## Add the letter onto the wrong_guesses array.
        if wrong_guesses.size >= 7 ## If there has been 7 or more incorrect guesses.
          @check_win_or_lose = :lose ## The game has been lossed.
        end
        return true
      end
    end
    return false
  end
  
   attr_accessor :word
   attr_accessor :guesses
   attr_accessor :wrong_guesses
   attr_accessor :word_with_guesses
   attr_accessor :check_win_or_lose
  

end