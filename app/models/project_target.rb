class ProjectTarget
  include Mongoid::Document
  include AASM

  belongs_to :project
  belongs_to :meaning

  field :state, type: String
  index({project_id: 1})
  index({project_id: 1, state: 1})
  index({project_id: 1, meaning_id: 1})

  after_save do |target|
    target.project.recalculate_counts!
  end

  aasm :column => :state do
    state :todo
    state :pending
    state :fixed
    state :invalid

    event :open_proposal do
      transitions from: :todo, to: :pending
    end

    event :meaning_deleted do |variable|
      transitions from: :todo, to: :invalid
    end

    event :complete do
      transitions from: :pending, to: :fixed
    end

    event :restart do
      transitions from: :pending, to: :todo
    end
  end
end
