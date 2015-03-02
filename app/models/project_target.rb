class ProjectTarget
  include Mongoid::Document
  include AASM

  belongs_to :project
  belongs_to :meaning

  field :state, type: String

  aasm :column => :state do
    state :todo
    state :pending
    state :fixed

    event :open_proposal do
      transitions from: :todo, to: :pending
    end

    event :complete do
      transitions from: :pending, to: :fixed
    end

    event :restart do
      transitions from: :pending, to: :todo
    end
  end

end
