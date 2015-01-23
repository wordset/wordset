class Suggestion
  include Mongoid::Document
  include AASM

  belongs_to :word
  belongs_to :user
  belongs_to :target, polymorphic: true

  field :delta, type: Hash
  field :action, type: String
  field :create_class_name, type: String
  field :state, type: String

  validates :user,
            :presence => true,
            :associated => true

  validates :action,
            :presence => true,
            :inclusion => {in: Proc.new() { Suggestion.actions } }

  validate :validate_suggestion, if: :new?

  index({target_id: 1, target_type: 1})
  index({target_id: 1, target_type: 1, status: 1})
  index({word_id: 1, status: 1})

  aasm :column => :state do
    state :new, initial: true
    state :accepted
    state :rejected

    event :approve, after: :commit_suggestion! do
      transitions from: :new, to: :accepted
    end

    event :reject do
      transitions from: :new, to: :rejected
    end
  end

  def self.actions; ["create", "destroy", "change"]; end
  def create?; action == "create"; end
  def create_class; create_class_name.constantize; end

  def commit_suggestion!
    case action
    when "create"
      model = create_class.new_from_suggestion(self)
      raise "create failed" unless model.save
      model
    when "destroy"
      target.destroy
      target
    when "change"
      model = target.apply_suggestion(self["delta"])
      model.save
      model
    end
  end

  def validate_suggestion
    target = self.create? ? create_class : self.target
    target.validate_suggestion(self, errors)
  end
end
