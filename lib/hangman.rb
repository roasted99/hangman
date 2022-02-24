require 'json'

module RandomWord
  
  @@words = File.read('google-10000-english-no-swears.txt').split("\n")

  def word_generator
    word = @@words.sample 
    if (word.length >= 5 && word.length <=12)
      word
    else
      return self.word_generator
    end
  end

end
include RandomWord
# p RandomWord.word_generator
# module SaveGame
  

#   def to_json
#     JSON.dump({
#       :word_to_match => @word_to_match,
#       :word_to_guess => @word_to_guess,
#       :wrong_guess => @wrong_guess,
#       :wrong_guess_count => @wrong_guess_count
#     })
#     end

#     def self.from_json(string)
#       data = JSON.load string
#       self.new(data['word_to_match'], data['word_to_guess'], data['guess_char'], data['wrong_guess_count'])
#     end

#   def save_game
#     Dir.mkdir('save') unless Dir.exit?('save')
    
#     save_file = File.new("save#{num}.json", "w")
#     save_file.puts data.to_json
#     num = 0
#     filename = "save/#{save_file}" unless filename.exit?
#     num += 1
#     save_file.close
      
#   end

#   def load_game
#     load_data = File.open("save/save#{num}.json", 'w')
#     load_data.from_json
#   end
# end


class Game
  include RandomWord
  def initialize 
    @word_to_match = RandomWord.word_generator
    @word_to_guess = word_to_match.gsub(/[\w]/, "_")
    @wrong_guess_count = 6
    @wrong_guess = []
  end

  attr_accessor :word_to_match, :word_to_guess, :wrong_guess_count, :wrong_guess

  def play_game 
    # word_to_match = RandomWord.word_generator
    # word_to_guess = 
    p word_to_match.to_s
    loop do
      puts "#{word_to_guess}"
      print "Guess a character: "
      guess_char = gets.chomp.to_s
      if word_to_match.include?(guess_char)
        correct_guess(guess_char)
        if word_to_guess == word_to_match
          puts "Congratulation! You've guessed it!"
        end
      else
        incorrect_guess(guess_char)
      end
      p "Wrong guess characters: #{wrong_guess.join(', ')}  Chance left: #{wrong_guess_count}"
    end
  end
  
  def game_over
    puts "Game Over. Press A if you want to try again."
      try_again = gets
      try_again.upcase
      if try_again == 'A' 
        play_game
      else
        puts "Command is not regonized. Press A to try again."
      end
  end

  def correct_guess(char)
    puts "Correct guess!"
    index = word_to_match.index(char)
    word_to_guess[index] = char
    word_to_guess
    
  end

  def incorrect_guess(char)
    puts "Opps! Wrong guess!"
    wrong_guess.push(char)
    @wrong_guess_count -= 1
    word_to_guess
    if wrong_guess_count == 1
      puts "Choose carefully. This is your last chance."
    elsif wrong_guess_count == 0
      self.game_over
    end
  end

end



game_1 = Game.new
game_1.play_game