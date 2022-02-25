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

class StartGame 

  def load_game
    puts "Hangman"
    puts "Press '1' to 'Start new game'."
    puts "Press '2' to 'Load game'."

    command = gets.chomp.to_s.downcase
    if command == '1'
      new_game = Game.new
      new_game.play_game
    elsif command == '2'
        save_game = Dir::entries("save")
        puts save_game

        select_file = gets.chomp.to_s.downcase
        load_save_game(select_file)
    end
  end

  def load_save_game(file_name)
    load_data = File.read("save/#{file_name}.json")
    p load_data
    self.from_json(load_data)
  end

  def from_json(string)
    data = JSON.load string
    load_file = Game.new(data['word_to_match'], data['word_to_guess'], data['guess_char'], data['wrong_guess_count'])
    load_file.play_game
  end

end


class Game
  include RandomWord
  def initialize(word_to_match = RandomWord.word_generator, word_to_guess = word_to_match.gsub(/[\w]/, "_"), wrong_guess_count = 6, wrong_guess = [] )
    @word_to_match = word_to_match
    @word_to_guess = word_to_guess
    @wrong_guess_count = wrong_guess_count
    @wrong_guess = wrong_guess
  end

  attr_accessor :word_to_match, :word_to_guess, :wrong_guess_count, :wrong_guess

  def play_game 
    puts word_to_match.to_s
    loop do
      puts "#{word_to_guess}"
      puts "Wrong guess characters: #{wrong_guess.join(', ')}  Chance left: #{wrong_guess_count}"
      print "Guess a character or type 'save' to save the game : "
      guess_char = gets.chomp.to_s.downcase
      if word_to_match.include?(guess_char)
        correct_guess(guess_char)
      
      elsif guess_char == 'save'
        self.save_game
        return
      elsif word_to_guess == word_to_match
          puts "Congratulation! You've guessed it!"
      elsif guess_char.length != 1
        puts "Wrong input! Please enter one character only."
      else 
          incorrect_guess(guess_char)
      end
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
    i = 0
    while i <= word_to_match.to_s.length do
      word_to_guess[i] = char if word_to_match[i] == char
      i += 1
      word_to_guess
    end
    
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

  def to_json
    JSON.dump({
      :word_to_match => @word_to_match,
      :word_to_guess => @word_to_guess,
      :wrong_guess => @wrong_guess,
      :wrong_guess_count => @wrong_guess_count
    })
  end

  def save_game
    Dir.mkdir('save') unless Dir.exists?('save')
    
    print "Enter the name: "
    name = gets.chomp.to_s
    
    file_name = "#{name}.json" 
    save_file = File.open("save/#{file_name}", "w") unless File.exist?("save/#{file_name}.json")
     
    save_file.puts self.to_json
   
    save_file.close 
  end

end



game_1 = StartGame.new
game_1.load_game