class SpeechPart
  include Mongoid::Document

  embedded_in :lang

  field :code, type: String
  field :name, type: String

  add_index({code: 1})

end
