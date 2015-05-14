class QuizQuestion
  include Mongoid::Document

  embedded_in :quiz
  embeds_many :quiz_answers

  accepts_nested_attributes_for :quiz_answers, allow_destroy: true

  field :text, type: String
  field :image_url, type: String

end
