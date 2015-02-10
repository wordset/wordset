class Proposal
  include Mongoid::Document
  include Mongoid::Timestamps
  include AASM

  belongs_to :word
  belongs_to :user

  has_many :votes

  field :state, type: String, as: "s"
  field :reason, type: String, as: "r"
  field :wordnet, type: Boolean, default: false, as: "wn"
  field :tally, type: Integer, default: 0
  field :flagged_value, type: Integer, default: 0

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
    state :flagged

    event :approve, after: :commit_proposal! do
      transitions from: :open, to: :accepted
    end

    event :reject do
      transitions from: :open, to: :rejected
    end

    event :flag, after: :cleanup_proposal! do
      transitions from: :open, to: :flagged
    end

  end

  def commit_proposal!
    if valid?
      commit!
      user.recalculate_points!
      user.save
    end
  end

  def cleanup_proposal!

  end

  def recalculate_tally!
    self.tally = votes.sum(:value)
    self.flagged_value = votes.where(flagged: true).sum(:value)
    if self.flagged_value <= -50
      flag!
    elsif self.tally >= 100
      approve!
    elsif self.tally <= -100
      reject!
    end
    self.save
  end

end
