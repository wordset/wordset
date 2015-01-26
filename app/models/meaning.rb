
class Meaning
  include Mongoid::Document
  include Suggestable
  field :def, type: String
  field :wordnet_import, type: Boolean, default: false
  field :example, type: String
  belongs_to :entry

  validates :entry,
            :presence => true,
            :associated => true
  validates :def,
            :length => {minimum: 10}
  validates :example,
            :length => {minimum: 10}

  index({entry_id: 1})

  def word
    entry.word
  end

  def self.suggestable_fields
    %w(def example)
  end
end
