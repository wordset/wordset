class WordMeaningQuote
  include Mongoid::Document
  field :text, type: String, as: "q"
  field :source, type: String, as: "s"
  embedded_in :word_meaning, inverse_of: :quotes
end
