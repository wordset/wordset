
class Entry
  include Mongoid::Document
  include PosLike
  has_many :meanings,
            autosave: true,
            dependent: :destroy
  belongs_to :word

  validates :word,
            :presence => true

  validates :meanings,
            :associated => true,
            :length => { :minimum => 1 },
            :on => :create

  index({word_id: 1})
  index({pos: 1})

  def self.pos
    %w(adv adj verb noun prep pronoun conj)
  end
end
