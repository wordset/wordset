
class Entry
  include Mongoid::Document
  include Suggestable
  field :pos, type: String
  has_many :meanings
  belongs_to :word

  validates :word,
            :presence => true,
            :associated => true

  def self.pos
    %w(adv adj verb noun)
  end
end
