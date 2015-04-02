class Lang
  include Mongoid::Document

  field :code

  index({code: 1})

  has_many :seqs
end
