
class Meaning
  include Mongoid::Document
  include Suggestable
  field :def, type: String
  has_many :quotes, autosave: true
  belongs_to :entry

  validates :entry,
            :presence => true,
            :associated => true

  validates :quotes,
            :associated => true,
            :length => { :minimum => 1 }

  def word
    entry.word
  end

  def self.suggestable_children
    %w(quotes)
  end

  def self.suggestable_fields
    %w(def)
  end
end
