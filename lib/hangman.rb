module RandomWord
  words = File.read('google-10000-english-no-swears.txt').split("\n")

  def word_generator(array)
    word = array.sample 
    if (word.length >= 5 && word.length <=12)
      word
    else
      return word_generator(array)
    end

  end
end


word_to_match = word_generator(words)
# word_to_guess = word_generator.gsub(/\w+/, "")

# class Game
#   def initialize(word, correct_guess, wrong_guess)
#     @word = word
#     @correct_guess = correct_guess
#     @wrong_guess = wrong_guess
#   end



  
# end