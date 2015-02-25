class Proposal
  include Mongoid::Document
  include Mongoid::Timestamps
  include AASM

  belongs_to :word
  belongs_to :user

  has_many :votes,
            dependent: :destroy
  has_many :activities,
            dependent: :destroy

  field :state, type: String, as: "s"
  field :reason, type: String, as: "r"
  field :wordnet, type: Boolean, default: false, as: "wn"
  field :tally, type: Integer, default: 0
  field :flagged_value, type: Integer, default: 0
  field :original, type: Hash

  field :edited_at, type: Time, default: lambda { Time.now }

  after_create :create_initial_activity!

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
  index({state: 1, created_at: -1, _id: 1})

  aasm :column => :state do
    state :open, initial: true
    state :accepted
    state :rejected
    state :flagged
    state :withdrawn

    event :approve, after: :commit_proposal! do
      transitions from: :open, to: :accepted
    end

    event :reject, after: :cleanup_proposal! do
      transitions from: :open, to: :rejected
    end

    event :flag, after: :cleanup_proposal! do
      transitions from: :open, to: :flagged
    end

    event :withdraw, after: :cleanup_proposal! do
      transitions from: :open, to: :withdrawn
    end

  end

  def pushUpdate!
    Pusher['proposals'].trigger('push',
      ProposalSerializer.new(self).to_json)
  end

  # Accessor that we use to either access the word belongs_to
  # or we override it in child proposals
  def word_name
    word.name
  end

  def commit_proposal!
    if valid?
      commit!
      create_final_activity!
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
    EditProposalActivity.create(user: self.user,
                                proposal: self,
                                word: self.word)
    recalculate_tally!
  end

  def cleanup_proposal!
    create_final_activity!
  end

  def recalculate_tally!
    self.tally = votes.where(:usurped => false, :withdrawn.in => [false, nil]).sum(:value)
    self.tally = 100 if self.tally > 100
    self.tally = -100 if self.tally < -100
    self.flagged_value = votes.where(flagged: true).sum(:value)
    if self.open?
      if self.flagged_value <= -50
        flag!
      elsif self.tally >= 100
        approve!
      elsif self.tally <= -100
        reject!
      end
    end
    self.save
  end

  def create_initial_activity!
    NewProposalActivity.create(user: self.user, proposal: self, word: self.word)
  end

  def create_final_activity!
    ProposalClosedActivity.create(user: self.user, proposal: self, word: self.word, final_state: self.state)
  end

end
