class Quiz
  include Mongoid::Document
  include AASM

  field :slug, type: String
  field :title, type: String

  embeds_many :quiz_questions
  embeds_many :quiz_results

  accepts_nested_attributes_for :quiz_questions, allow_destroy: true

  field :state, type: String

  index({state: 1})
  index({state: 1, slug: 1})

  aasm :column => :state do
    state :draft, initial: true
    state :rejected
    state :published

    event :publish, before: :set_published_at do
      transitions from: :draft, to: :published
    end

    event :reject do
      transitions from: :draft, to: :published
    end
  end

end
