module AnagramHelpers
  extend ActiveSupport::Concern

  included do |base|
    base.field :alpha, type: String, as: "a"
    base.before_create :calculate_alpha!
  end

  class_methods do
    def randogram()
      meaning = Meaning.limit(1).offset(rand(Meaning.count)).first
      anagram = anagram_of(meaning.word.text).shuffle.first
      [meaning.word.text, anagram.join(" "), meaning.def]
    end

    def simple_anagrams_of(input)
      # search for simple anagrams
      texts = all_alpha_matches(input)
      # Get rid of exact matches, even with
      # spaces, quotes, capitalization, etc.
      texts.reject! do |text|
        clean_letters(text) == clean_letters(input)
      end
      texts
    end

    # returns all sorted alpha matches
    def all_alpha_matches(input)
      where(alpha: sort_letters(input)).pluck :text
    end

    def anagram_of(input)
      anagram_searcher(input)
    end

    def find_right(left, full)
      counts = left.inject(Hash.new(0)) { |h, v| h[v] += 1; h }
      full.reject { |e| counts[e] -= 1 unless counts[e].zero? }
    end

    def anagram_searcher(input)
      cleaned_input = sort_letters(input)
      ignore = {}
      anagrams = []
      full_chars = cleaned_input.chars
      all_substrings(cleaned_input) do |left_arr|
        left = left_arr.join
        if ignore[left] == nil
          right = find_right(left_arr, full_chars).join
          lmatches = all_alpha_matches(left)
          if lmatches.length > 0
            if right.length > 1
              rmatches = all_alpha_matches(right)
              if rmatches.length > 0
                anagrams += lmatches.product(rmatches)
              end
            elsif right.length == 0
              anagrams += lmatches.zip
            end
          end
          ignore[left] = true
          ignore[right] = true
          #puts "ignore #{left} #{right}"
        end
      end
      anagrams
    end

    def all_substrings(str)
      chars = str.chars
      (chars.length - 2).times do |index|
        chars.combination(index + 3).each do |set|
          yield set
        end
      end
    end

    def clean_letters(input)
      input.downcase.gsub(/[^a-z]/,"")
    end

    def sort_letters(text)
      clean_letters(text).chars.sort.join
    end
  end

  def calculate_alpha!
    self.alpha = Wordset.sort_letters(text)
  end
end
