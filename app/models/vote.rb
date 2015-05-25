class Vote
  include Mongoid::Document
  include Mongoid::Timestamps
  include Badger

  belongs_to :user
  index({user_id: 1})
  index({user_id: 1, usurped: 1, withdrawn: 1})
  index({user_id: 1, proposal_id: 1, withdrawn: 1, usurped: 1})
  belongs_to :proposal#, autosave: true
  index({proposal_id: 1})
  index({proposal_id: 1, flagged: 1, value: 1})
  index({proposal_id: 1, withdrawn: 1, usurped: 1, value: 1})

  field :value, type: Integer
  field :flagged, type: Boolean, as: "f", default: false
  index({proposal_id: 1, flagged: 1, withdrawn: 1, usurped: 1})
  field :yae, type: Boolean, as: "y", default: true
  field :skip, type: Boolean, as: "s", default: false

  field :trust_points, type: Integer, as: "tp", default: 0
  index({user_id: 1, trust_points: 1, withdrawn: 1, usurped: 1})

  field :autovote, type: Boolean, as: "av", default: false

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

  before_save :calculate_trust_points
  after_save :run_tally


  validates :user,
            presence: :true#,
            #associated: :true
  validates :proposal,
            presence: :true#,
            #associated: :true
  validate  :check_uniqueness,
            on: :create
  validate  :check_proposal_open,
            on: :create

  badge do
    base_levels [1, 10, 50, 100, 250]
  end

  def nay?
    !is_yae
  end

  def create_activity!
    if !self.skip && !self.autovote
      VoteActivity.create(proposal: self.proposal, user: self.user, vote_value: self.value)
    end
  end

  def withdraw!
    self.update_attributes(withdrawn: true)
    WithdrawVoteActivity.create(proposal: self.proposal, user: self.user)
    run_tally
  end

  def proposal_just_closed!
    calculate_trust_points
    self.save!
    user.save!
  end

  private

  def calculate_value
    if yae?
      self.value = user.vote_value
    elsif skip?
      self.value = 0
    else
      self.value = user.vote_value*-1
    end
  end

  def run_tally
    proposal.recalculate_tally!
  end

  def calculate_trust_points
    if !proposal.open?
      if with_majority?
        self.trust_points = 1
      else
        self.trust_points = -1
      end
    else
      self.trust_points = 0
    end
  end

  def with_majority?
    if proposal.accepted? && self.yae?
      return true
    elsif proposal.rejected? && !self.yae?
      return true
    end
    false
  end

  def check_uniqueness
    if Vote.where(user: user, proposal: proposal, usurped: false, :withdrawn.in => [false, nil]).count != 0
      errors.add :user, "You can only vote once per proposal."
    end
  end

  def check_proposal_open
    if !proposal.open?
      errors.add :proposal, "Sorry, voting has ended on this proposal."
    end
  end

  def recalculate_points!
    self.user.recalculate_points!
  end
end
