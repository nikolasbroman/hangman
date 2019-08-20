class Hangman

  def initialize
    @secret_word
    @secret_word_with_underscores
    @correct_guesses = []
    @incorrect_guesses = []
  end

  def play
    new_game
  end

  private

  def new_game
    set_secret_word
    set_secret_word_with_underscores
    guess = get_guess
    #check whether guess is correct or incorrect -> add to array
    #if correct, update @secret_word_with_underscores
    #check if win
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
    puts "Next guess:"
    while guess = gets.chomp.downcase
      return guess if check_guess(guess)
    end
  end

  def check_guess(guess)
    if @correct_guesses.include?(guess) || @incorrect_guesses.include?(guess)
      puts "You have already guessed '#{guess}'. Try a new guess:"
      false
    elsif guess.length != 1 && guess.length != @secret_word.length
      puts "Your guess should be 1 letter or the entire word (#{@secret_word.length} lettters):"
      false
    else
      true
    end
  end

end

hangman = Hangman.new
hangman.play