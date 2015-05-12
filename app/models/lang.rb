class Lang
  include Mongoid::Document

  field :code
  field :name

  index({code: 1})

  has_many :speech_parts
  has_many :seqs
  has_many :proposals
  has_many :wordsets
  has_many :labels

end
