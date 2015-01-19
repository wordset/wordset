class Suggestion
  include Mongoid::Document
  belongs_to :parent, class_name: "Suggestion"
  belongs_to :word
  belongs_to :user
  belongs_to :target, polymorphic: true

  field :data, type: Hash
  field :action, type: String

  validates :user,
            :presence => true,
            :associated => true
  validates :action,
            :presence => true,
            :inclusion => {in: Proc.new() { Suggestion.actions } }

  def self.actions
    ["create", "destroy", "change"]
  end

  state_machine :initial => :new do
    event :approve do
      transition :new => :approved
    end

    state :new do
      validate {|s| s.target.validate_suggestion(self, errors) }
    end
  end
end
