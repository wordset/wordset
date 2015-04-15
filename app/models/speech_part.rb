class SpeechPart
  include Mongoid::Document

  belongs_to :lang

  has_many :meanings

  field :code, type: String
  field :name, type: String

  index({code: 1})

end
