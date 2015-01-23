
class Meaning
  include Mongoid::Document
  include Suggestable
  field :def, type: String
  field :wordnet_import, type: Boolean, default: false
  has_many :quotes, autosave: true
  belongs_to :entry

  validates :entry,
            :presence => true,
            :associated => true

  validates :quotes,
            :associated => true,
            :length => { :minimum => 1 },
            :unless => :wordnet_import?

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
