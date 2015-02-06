class Proposal
  include Mongoid::Document
  include Mongoid::Timestamps
  include AASM

  belongs_to :word
  belongs_to :user

  field :state, type: String, as: "s"
  field :reason, type: String, as: "r"
  field :wordnet, type: Boolean, default: false, as: "wn"

  validates :user,
            :presence => true,
            :associated => true,
            :unless => :wordnet?

  index({word_id: 1, status: 1})
  index({word_id: 1, created_at: -1})
  index({user_id: 1})
  index({created_at: -1})
  index({_type: 1})

  aasm :column => :state do
    state :open, initial: true
    state :accepted
    state :rejected

    event :approve, after: :commit_proposal! do
      transitions from: :open, to: :accepted
    end

    event :reject do
      transitions from: :open, to: :rejected
    end
  end

  def commit_proposal!
    if valid?
      commit!
      user.recalculate_points!
      user.save
    end
  end
end
