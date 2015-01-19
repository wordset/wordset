
class Entry
  include Mongoid::Document
  field :pos, type: String
  has_many :meanings
  belongs_to :word

  def self.pos
    %w(adv adj verb noun)
  end
end
