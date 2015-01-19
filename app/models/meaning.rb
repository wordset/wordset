
class Meaning
  include Mongoid::Document
  field :def, type: String
  has_many :quotes
  belongs_to :entry
end
