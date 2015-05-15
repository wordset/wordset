class Quiz
  include Mongoid::Document
  include AASM

  belongs_to :lang

  field :slug, type: String
  field :title, type: String

  validates :title, presence: true
  validates :slug,  presence: true

  embeds_many :quiz_questions, cascade_callbacks: true
  embeds_many :quiz_results, cascade_callbacks: true

  mount_uploader :image, ImageUploader

  accepts_nested_attributes_for :quiz_questions, allow_destroy: true
  accepts_nested_attributes_for :quiz_results, allow_destroy: true

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
