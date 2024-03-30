# frozen_string_literal: true

require 'yaml'

class Hangman
  attr_reader :secret_word, :remaining_incorrect_guesses, :guessed_letters

  def initialize(
    secret_word,
    remaining_incorrect_guesses = 11,
    correctly_guessed_letters = Array.new(secret_word.length, '_'),
    guessed_letters = []
  )
    @secret_word = secret_word.downcase
    @remaining_incorrect_guesses = remaining_incorrect_guesses
    @correctly_guessed_letters = correctly_guessed_letters
    @guessed_letters = guessed_letters
  end

  def guess_letter(letter)
    letter = letter.downcase
    if @guessed_letters.include?(letter)
      return false
    elsif secret_word.include?(letter)
      secret_word.split('').each_with_index do |char, index|
        @correctly_guessed_letters[index] = letter if char == letter
      end
    else
      @remaining_incorrect_guesses -= 1
    end

    @guessed_letters << letter
    true
  end

  def guess_word(word)
    word = word.downcase
    return false unless word.length == secret_word.length

    if word == secret_word
      @correctly_guessed_letters = word.split('')
    else
      @remaining_incorrect_guesses -= 1
    end
    true
  end

  def won?
    secret_word == @correctly_guessed_letters.join('')
  end

  def to_yaml
    YAML.dump({
                secret_word: @secret_word,
                remaining_incorrect_guesses: @remaining_incorrect_guesses,
                correctly_guessed_letters: @correctly_guessed_letters,
                guessed_letters: @guessed_letters
              })
  end

  def self.from_yaml(string)
    data = YAML.load string
    p data
    new(
      data[:secret_word],
      data[:remaining_incorrect_guesses],
      data[:correctly_guessed_letters],
      data[:guessed_letters]
    )
  end

  def print_game_information
    puts @correctly_guessed_letters.join ' '
    puts "remaining incorrect guesses: #{@remaining_incorrect_guesses}"
    puts "guessed letters: #{@guessed_letters.join(', ')}"
  end
end

