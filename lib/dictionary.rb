# frozen_string_literal: true
require 'open-uri'

class Dictionary

  attr_accessor :words

  def initialize(
    filename,
    url = 'https://raw.githubusercontent.com/first20hours/google-10000-english/master/google-10000-english-no-swears.txt'
  )
    unless File.exist? filename
      URI.open(url) do |remote_file|
        File.open(filename, 'wb') do |file|
          file.write(remote_file.read || '')
        end
      end
    end
    @words = File.open(filename).readlines(chomp: true)
  end

  def get_random_word(min_length, max_length)
    unless words.any? { |word| word.length >= min_length && word.length <= max_length }
      raise ArgumentError, 'There is no word in the dictionary that meets the requirements'
    end

    shuffle_words = words.shuffle
    shuffle_words.find { |word| word.length >= min_length && word.length <= max_length }
  end
end
