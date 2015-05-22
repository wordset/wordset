class Proposal
  include Mongoid::Document
  include Mongoid::Timestamps
  include AASM
  include Badger

  belongs_to :wordset
  belongs_to :user
  belongs_to :project
  belongs_to :lang

  has_many :votes,
            dependent: :destroy

  field :state, type: String, as: "s"
  field :reason, type: String, as: "r"
  field :wordnet, type: Boolean, default: false, as: "wn"
  field :tally, type: Integer, default: 0
  field :flagged_value, type: Integer, default: 0
  field :original, type: Hash
  field :word_name, type: String, as: "w", default: ""

  field :vote_user_ids, type: Array

  # Having a note is special, it means that the
  # system did something, and it disables certain
  # normal events, like pusher, etc.
  field :note, type: String, as: "note"

  field :edited_at, type: Time, default: lambda { Time.now }

  before_create :cache_word_name!

  after_create :vote_on_it!
  after_create :create_initial_activity!

  badge :proposer do
    base_levels [1, 5, 10, 25, 50]
    on :after_save
    value do |model|
      model.user.proposals.where(state: "accepted").count
    end
  end

  validates :user,
            :associated => true
  validates :lang,
            :presence => true

  index({wordset_id: 1, state: 1})
  index({wordset_id: 1, created_at: -1})
  index({user_id: 1})
  index({user_id: 1, state: 1})
  index({user_id: 1, created_at: -1})
  index({created_at: -1})
  index({vote_user_ids: 1, state: 1})
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
    if note.blank?
      Pusher['proposals'].trigger('push',
        ProposalSerializer.new(self).to_json)
    end
  end

  def vote_on_it!
    if self.user
      Vote.create(proposal: self, user: user, yae: true, autovote: true)
    end
  end

  def commit_proposal!
    if valid?
      commit!
      create_final_activity!
      if user
        user.recalculate_points!
        user.save
      end
    end
  end

  # Call this if the user just did an edit and
  # you want to reset everything.
  def finished_edit!
    self.edited_at = Time.now
    self.votes.where(:autovote.ne => true).each do |v|
      v.update_attributes(usurped: true)
    end
    EditProposalActivity.create(user: self.user,
                                proposal: self)
    recalculate_tally!
  end

  def cleanup_proposal!
    create_final_activity!
  end

  def recalculate_tally
    vote_list = votes.where(:usurped => false, :withdrawn.in => [false, nil])
    self.vote_user_ids = votes.pluck :user_id
    self.tally = vote_list.sum(:value)
    self.tally = 100 if self.tally > 100
    self.tally = -100 if self.tally < -100
    self.flagged_value = votes.where(flagged: true).sum(:value)
  end

  def recalculate_tally!
    recalculate_tally
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
    if self.user
      NewProposalActivity.create(user: self.user, proposal: self)
    end
  end

  def create_final_activity!
    if note.blank? && !flagged?
      ProposalClosedActivity.create(user: self.user, proposal: self, final_state: self.state)
    end
    self.votes.each &:proposal_just_closed! #Make sure we trigger recalculating votes
  end

  def activities
    Activity.where(proposal_id: self.id)
  end

  def cache_word_name!
    if wordset
      self.word_name = wordset.name
    end
  end

end
