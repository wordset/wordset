class WordMeaningSerializer < BaseSerializer
  attributes :id, :def
  has_many :quotes
end
