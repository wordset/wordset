class WordEntry
  include Mongoid::Document
  field :pos, :type => String
  embeds_many :meanings, class_name: "WordMeaning"
  embeds_many :forms, class_name: "WordForm"
  embedded_in :word, inverse_of: :entry
end
