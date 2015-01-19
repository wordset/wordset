class Suggestion
  include Mongoid::Document
  belongs_to :parent, class_name: "Suggestion"
  belongs_to :word
  belongs_to :user
  belongs_to :target, polymorphic: true

  field :data, type: Hash
  field :action, type: String
  field :create_class_name, type: String

  validates :user,
            :presence => true,
            :associated => true
  validates :action,
            :presence => true,
            :inclusion => {in: Proc.new() { Suggestion.actions } }

  def self.actions
    ["create", "destroy", "change"]
  end

  def create?
    action == "create"
  end

  def create_class
    create_class_name.constantize
  end

  def create_class=(klass)
    if klass.suggestable?
      create_class_name = klass.to_s
    else
      throw "Not suggestable class!"
    end
  end

  state_machine :initial => :new do
    event :approve do
      transition :new => :approved
    end

    state :new do
      validate do |s|
        target = s.create? ? create_class : s.target
        target.validate_suggestion(self, errors)
      end
    end
  end
end
