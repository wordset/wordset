class WordForm
  include Mongoid::Document
  field :text

  embedded_in :word_entry, inverse_of: :form
end
