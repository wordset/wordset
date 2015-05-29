class ProjectTarget
  include Mongoid::Document
  include Mongoid::Timestamps
  include AASM

  belongs_to :project
  belongs_to :meaning

  field :state, type: String
  index({project_id: 1})
  index({project_id: 1, state: 1})
  index({project_id: 1, meaning_id: 1})

  after_save(on: :update) do |target|
    target.project.recalculate_counts!
  end

  aasm :column => :state do
    state :todo, initial: true
    state :pending
    state :fixed
    state :marked_invalid

    event :open_proposal do
      transitions from: :todo, to: :pending
    end

    event :meaning_deleted do
      transitions from: :todo, to: :marked_invalid
    end

    event :complete do
      transitions from: :pending, to: :fixed
    end

    event :restart do
      transitions from: :pending, to: :todo
    end
  end
end
