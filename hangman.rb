class Hangman

  def initialize
    @secret_word
    @secret_word_with_underscores
    @MAX_GUESSES = 13
    @correct_guesses = []
    @incorrect_guesses = []
    @victory = false
  end

  def play
    new_game
  end

  private

  def new_game
    new_round
  end


  def new_round
    set_secret_word
    set_secret_word_with_underscores
    puts
    puts @secret_word_with_underscores
    1.upto(@MAX_GUESSES) do |i|
      puts
      puts
      puts "Guess #{i}/#{@MAX_GUESSES}:"
      guess = get_guess
      check_matches(guess)
      puts
      if @victory
        puts @secret_word.split("").join(" ")
        puts "Congratulations! You did it!"
        return
      else
        puts @secret_word_with_underscores
      end
      if @incorrect_guesses.length > 0
        puts
        puts "Incorrect guesses: "
        puts @incorrect_guesses.join(", ")
      end
    end
    puts "Game over. You lost."
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

  def get_guess
    while guess = gets.chomp.downcase
      return guess if check_guess(guess)
    end
  end

  def check_guess(guess)
    if @correct_guesses.include?(guess) || @incorrect_guesses.include?(guess)
      puts "You have already guessed '#{guess}'. Try a new guess:"
      false
    elsif guess.length != 1 && guess.length != @secret_word.length
      #todo: check that guess consists only of a-z
      puts "Your guess should be 1 letter or the entire word (#{@secret_word.length} lettters):"
      false
    else
      true
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