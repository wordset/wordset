class SpeechPart
  include Mongoid::Document

  belongs_to :lang

  has_many :meanings

  has_and_belongs_to_many :labels

  field :code, type: String
  field :name, type: String

  index({code: 1})

end
