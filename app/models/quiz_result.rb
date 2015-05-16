class QuizResult
  include Mongoid::Document

  embedded_in :quiz
  embeds_many :quiz_answers

  mount_uploader :image, ImageUploader

  field :name, type: String
  validates :name, presence: true
  field :image_url, type: String
  field :description, type: String

end
