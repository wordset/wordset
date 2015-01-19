
class Meaning
  include Mongoid::Document
  include Suggestable
  field :def, type: String
  has_many :quotes
  belongs_to :entry

  validates :entry,
            :presence => true,
            :associated => true

  def word
    entry.word
  end
end
