class QuizQuestion
  include Mongoid::Document

  embedded_in :quiz
  embeds_many :quiz_answers

  mount_uploader :image, ImageUploader

  accepts_nested_attributes_for :quiz_answers, allow_destroy: true

  field :text, type: String
  validates :text, presence: true
  field :image_url, type: String
  field :image_link, type: String
  field :image_citation, type: String

end
