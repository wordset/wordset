class Lang
  include Mongoid::Document

  has_many :speech_parts

  field :code
  field :name

  index({code: 1})

  has_many :seqs
  has_many :proposals
  has_many :wordsets
end
