# frozen_string_literal: true

require './lib/dictionary'
require './lib/hangman'

save_file_name = 'hangman_save.yaml'

dictionary = Dictionary.new('dictionary.txt')
secret_word = dictionary.get_random_word(5, 12)

hangman = Hangman.new(secret_word)
hangman = Hangman.from_yaml(File.read(save_file_name)) if ARGV[0] == '-load' && File.exist?(save_file_name)
result_message = "You lost!, the correct word was: #{hangman.secret_word}"

system 'clear'
while hangman.remaining_incorrect_guesses.nonzero?
  hangman.print_game_information
  if hangman.won?
    result_message = 'You won!'
    break
  end
  puts '(enter "-save" to stop and save the game)'
  print 'guess a letter or a word: '
  guess = $stdin.gets.chomp
  system 'clear'
  if guess == '-save'
    File.open(save_file_name, 'w') do |file|
      file.write(hangman.to_yaml)
    end
    result_message = ''
    break
  elsif guess.length == 1
    puts 'You had already guessed this letter!' unless hangman.guess_letter(guess)
  else
    puts 'the length of the word you entered is incorrect' unless hangman.guess_word(guess)
  end
end

unless result_message.empty?
  puts result_message
  File.delete(save_file_name)
end
