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
  field :original, type: Hash

  field :edited_at, type: Time, default: lambda { Time.now }

  validates :user,
            :presence => true,
            :associated => true,
            :unless => :wordnet?

  index({word_id: 1, state: 1})
  index({word_id: 1, created_at: -1})
  index({user_id: 1})
  index({created_at: -1})
  index({_type: 1})
  index({state: 1})

  aasm :column => :state do
    state :open, initial: true
    state :accepted
    state :rejected
    state :flagged

    event :approve, after: :commit_proposal! do
      transitions from: :open, to: :accepted
    end

    event :reject, after: :cleanup_proposal! do
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

  # Call this if the user just did an edit and
  # you want to reset everything.
  def finished_edit!
    self.edited_at = Time.now
    self.votes.each do |v|
      v.update_attributes(usurped: true)
    end
    recalculate_tally!
  end

  def cleanup_proposal!

  end

  def recalculate_tally!
    self.tally = votes.where(:usurped => false).sum(:value)
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
