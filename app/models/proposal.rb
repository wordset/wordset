class Proposal
  include Mongoid::Document
  include Mongoid::Timestamps
  include AASM

  belongs_to :word
  belongs_to :user
  belongs_to :target, polymorphic: true
  belongs_to :proposal
  has_many :proposals

  field :delta, type: Hash, as: "d"
  field :action, type: String, as: "a"
  field :create_class_name, type: String, as: "ccn"
  field :state, type: String, as: "s"
  field :wordnet, type: Boolean, default: false, as: "wi"

  validates :user,
            :presence => true,
            :associated => true,
            :unless => :wordnet?

  validates :action,
            :presence => true,
            :inclusion => {in: Proc.new() { Proposal.actions } }

  validate :validate_proposal, if: :new?

  index({target_id: 1, target_type: 1})
  index({target_id: 1, target_type: 1, status: 1})
  index({word_id: 1, status: 1})
  index({created_at: -1})

  before_create :set_previous_proposal

  aasm :column => :state do
    state :new, initial: true
    state :accepted
    state :rejected

    event :approve, after: :commit_proposal! do
      transitions from: :new, to: :accepted
    end

    event :reject do
      transitions from: :new, to: :rejected
    end
  end

  def self.actions; ["create", "destroy", "change"]; end
  def create?; action == "create"; end
  def create_class; create_class_name.constantize; end

  def commit_proposal!
    case action
    when "create"
      model = create_class.new_from_proposal(self)
      raise "create failed" unless model.save
      model
    when "destroy"
      target.destroy
      target
    when "change"
      model = target.apply_proposal(self["delta"])
      model.save
      model
    end
  end

  def set_previous_proposal
    self.proposal = target.proposals.where(state: "accepted").sort(created_at: -1).first
  end

  def validate_proposal
    target = self.create? ? create_class : self.target
    target.validate_proposal(self, errors)
  end
end
