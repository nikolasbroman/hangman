class Hangman

  def initialize
    @secret_word = get_secret_word
  end

  def get_secret_word
    word_list = File.readlines("5desk.txt").map(&:chomp)
    secret_word = ""
    until secret_word.length.between?(5,12) && secret_word[0] =~ /[a-z]/
      secret_word = word_list.sample
    end
    secret_word
  end

end

hangman = Hangman.new