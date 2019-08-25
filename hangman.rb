require "yaml"

class Hangman

  def initialize
    @loading = false
    @secret_word
    @secret_word_with_underscores
    @guess_index = 1
    @MAX_GUESSES = 13
    @correct_guesses = []
    @incorrect_guesses = []
    @victory = false
    @exit = false
  end

  def play
    new_game_or_load_game
  end

  private

  def before_prompt
    print "> "
  end

  def new_game_or_load_game
    puts "Play a new game or load previous game?"
    puts "1) New Game"
    puts "2) Load Game"
    before_prompt
    while input = gets.chomp.downcase
      case input
      when "1", "new", "newgame", "new game"
        @loading = false
        break
      when "2", "load", "loadgame", "load game"
        @loading = true
        break
      else
        puts "Please try again:"
        before_prompt
      end
    end
    new_game
  end


  def new_game
    new_round
    while !@exit && ask_if_new_round
      new_round
    end
    puts
    puts "Thank you for playing."
    puts
  end

  def ask_if_new_round
    puts
    puts "Play a new round? (yes/no)"
    before_prompt
    while input = gets.chomp.downcase
      case input
      when "y", "yes"
        return true
      when "n", "no"
        return false
      else
        puts "Please answer yes or no."
        before_prompt
      end
    end
  end


  def new_round
    puts
    if @loading
      @exit = false
      load_game
    else
      set_secret_word
      set_secret_word_with_underscores
      @guess_index = 1
      @correct_guesses = []
      @incorrect_guesses = []
    end
    begin_guessing
    @loading = false
  end

  def load_game
    data = YAML.load File.read("save.txt")
    @secret_word = data[:secret_word]
    @secret_word_with_underscores = data[:secret_word_with_underscores]
    @guess_index = data[:guess_index]
    @correct_guesses = data[:correct_guesses]
    @incorrect_guesses = data[:incorrect_guesses]
  end

  def set_secret_word
    word_list = File.readlines("5desk.txt").map(&:chomp)
    while secret_word = word_list.sample
      break if secret_word.length.between?(5,12) && secret_word[0] =~ /[a-z]/
    end
    @secret_word = secret_word
  end

  def set_secret_word_with_underscores
    @secret_word_with_underscores = ("_" * @secret_word.length).split("").join(" ")
  end

  def begin_guessing
    update_display
    while @guess_index <= @MAX_GUESSES
      puts
      puts "Guess #{@guess_index}/#{@MAX_GUESSES}:"
      guess = get_guess
      if guess == "save"
        save_game_and_exit
        return
      end
      check_matches(guess)
      if @victory
        @secret_word_with_underscores = @secret_word.split("").join(" ")
        update_display
        puts "Congratulations! You won!"
        @victory = false
        return
      else
        update_display
        @guess_index += 1
      end
    end
    puts
    puts "Game over."
    puts "The word was '#{@secret_word}'."
  end

  def update_display
    if @incorrect_guesses.length > 0
      puts
      puts "Incorrect guesses: "
      puts @incorrect_guesses.join(", ")
    end
    puts
    puts @secret_word_with_underscores
    puts
  end

  def get_guess
    before_prompt
    while guess = gets.chomp.downcase
      return guess if guess == "save" || check_guess(guess)
      before_prompt
    end
  end

  def save_game_and_exit
    serialized = YAML.dump ({
      secret_word: @secret_word,
      secret_word_with_underscores: @secret_word_with_underscores,
      guess_index: @guess_index,
      correct_guesses: @correct_guesses,
      incorrect_guesses: @incorrect_guesses
    })
    File.open("save.txt", "w"){ |file| file.puts serialized }
    puts
    puts "Your game has been saved."
    @exit = true
  end

  def check_guess(guess)
    if @correct_guesses.include?(guess) || @incorrect_guesses.include?(guess)
      puts "You have already guessed '#{guess}'. Try a new guess:"
      false
    elsif guess.length != 1 && guess.length != @secret_word.length
      puts "Your guess should be 1 letter or the entire word (#{@secret_word.length} lettters):"
      false
    elsif guess =~ /^[a-z]+$/
      true
    else
      puts "Your guess should only consist of letters (a-z):"
      false
    end
  end

  def check_matches(guess)
    if guess.length > 1 && guess == @secret_word
      @victory = true
    elsif @secret_word.include?(guess)
      add_letters(guess)
      @correct_guesses << guess
    else
      @incorrect_guesses << guess
    end
  end

  def add_letters(guess)
    new_word = @secret_word_with_underscores.split(" ").join("")
    @secret_word.split("").each_with_index do |letter, index|
      new_word[index] = guess if letter == guess
    end
    @victory = true if new_word == @secret_word
    @secret_word_with_underscores = new_word.split("").join(" ")
  end

end

hangman = Hangman.new
hangman.play
