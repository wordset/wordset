module ProperNounDestroyer
  extend ActiveSupport::Concern

  included do |base|

  end

  class_methods do
    def capitalized_nouns
      count = 0
      saves = 0
      capitalized_words.each do |word|
        if !word.entries.ne(pos: "noun").any?
          word.entries.where(pos: "noun").first.meanings.each do |meaning|
            yield meaning
          end
        end
      end
    end

    def capitalized_words
      self.where(name: /\A[A-Z]/)
    end

    def dated_meanings
      Meaning.where(def: /[\d]{4}[\-]{1}[\d]{4}/).includes(:entry)
    end
  end
end
