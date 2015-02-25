class Vote
  include Mongoid::Document
  include Mongoid::Timestamps

  belongs_to :user
  index({user_id: 1})
  index({user_id: 1, usurped: 1})
  index({user_id: 1, proposal_id: 1})
  belongs_to :proposal
  index({proposal_id: 1})

  field :value, type: Integer
  field :flagged, type: Boolean, as: "f", default: false
  index({proposal_id: 1, flagged: 1})
  field :yae, type: Boolean, as: "y", default: true

  # If a vote has been usurped, that is a revision
  # was made on the proposal, so this doesn't
  # count anymore.
  field :usurped, type: Boolean, default: false, as: "u"

  # If a vote is withdrawn, this should be
  # set to true
  field :withdrawn, type: Boolean, default: false, as: "w"

  before_create :calculate_value
  after_create :recalculate_points!
  after_create :create_activity!
  after_save :run_tally

  validates :user,
            presence: :true,
            associated: :true
  validates :proposal,
            presence: :true,
            associated: :true
  validate  :check_uniqueness,
            on: :create
  validate  :check_proposal_open,
            on: :create


  def nay?
    !is_yae
  end

  def create_activity!
    VoteActivity.create(proposal: self.proposal, user: self.user, word: self.proposal.word, vote_value: self.value)
  end

  def withdraw!
    self.update_attributes(withdrawn: true)
    WithdrawVoteActivity.create(proposal: self.proposal, user: self.user, word: self.proposal.word)
    run_tally
  end

  private

  def calculate_value
    if yae?
      self.value = user.vote_value
    else
      self.value = user.vote_value*-1
    end
  end

  def run_tally
    proposal.recalculate_tally!
  end

  def check_uniqueness
    if Vote.where(user: user, proposal: proposal, usurped: false, :withdrawn.in => [false, nil]).count != 0
      errors.add :user, "You can only vote once per proposal."
    end
  end

  def check_proposal_open
    if proposal.open?
    else
      errors.add :proposal, "Sorry, voting has ended on this proposal."
    end
  end

  def recalculate_points!
    self.user.recalculate_points!
  end



end
