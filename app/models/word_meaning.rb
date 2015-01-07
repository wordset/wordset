class WordMeaning
  include Mongoid::Document
  field :def, type: String
  embedded_in :word_entry, inverse_of: :meaning
  embeds_many :quotes, class_name: "WordMeaningQuote"
end
