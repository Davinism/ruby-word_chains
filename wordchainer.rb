require 'set'

class WordChainer

  attr_reader :dictionary, :all_seen_words_hash

  def initialize(dictionary_file_name)
    @dictionary = File.readlines(dictionary_file_name).map(&:chomp).to_set
  end

  def run(source, target)
    @current_words = [source]
    @all_seen_words_hash = { source => nil }

    until @current_words.empty? || @all_seen_words_hash.keys.include?(target)
      explore_current_words
    end
    path = [target]
    until path[-1] == source
      path << build_path(path.last)
    end
    path
  end

  private

  def build_path(target)
    @all_seen_words_hash[target]

  end

  def explore_current_words
    new_current_words = []
     @current_words.each do |current_word|
       adjacent_words(current_word).each do |adjacent_word|
         unless @all_seen_words_hash.keys.include?(adjacent_word)
           @all_seen_words_hash[adjacent_word] = current_word
           new_current_words << adjacent_word
         end
       end
     end
     new_current_words.each do |word|
       print word
       puts "     #{@all_seen_words_hash[word]}"
     end
     @current_words = new_current_words
  end

  def adjacent_words(word)
    alphabet = ("a".."z").to_a
    letters = word.split('')
    found_words = []
    letters.each_with_index do | letter, idx |
      alphabet.each do | alpha_letter |
        letters[idx] = alpha_letter
        check_word = letters.join('')
        found_words << check_word if @dictionary.include?(check_word) &&
          check_word != word
        letters[idx] = letter
      end
    end
    found_words
  end

end

chainer = WordChainer.new("dictionary.txt")
p chainer.run("market", "master")
