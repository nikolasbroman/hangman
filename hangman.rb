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
    #get guess, check input
    #check whether guess is correct or incorrect -> add to array
    #if correct, update @secret_word_with_underscores
    #check if win
  end

  def set_secret_word
    word_list = File.readlines("5desk.txt").map(&:chomp)
    secret_word = ""
    until secret_word.length.between?(5,12) && secret_word[0] =~ /[a-z]/
      secret_word = word_list.sample
    end
    @secret_word = secret_word
  end

  def set_secret_word_with_underscores
    @secret_word_with_underscores = ("_" * @secret_word.length).split("").join(" ")
  end

end

hangman = Hangman.new
hangman.play