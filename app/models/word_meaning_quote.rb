class WordMeaningQuote
  include Mongoid::Document
  field :text, type: String
  embedded_in :word_meaning, inverse_of: :quotes
end
