class Lang
  include Mongoid::Document

  embeds_many :speech_parts

  field :code
  field :name

  index({code: 1})

  has_many :seqs
  has_many :proposals
  has_many :wordsets
end
