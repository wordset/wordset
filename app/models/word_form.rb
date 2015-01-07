class WordForm
  include Mongoid::Document
  field :text

  embedded_in :word_entry, inverse_of: :form

  index({text: 1}, {unique: true})
end
