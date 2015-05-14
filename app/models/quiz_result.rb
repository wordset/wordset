class QuizResult
  include Mongoid::Document

  embedded_in :quiz
  embeds_many :quiz_answers
  has_many :quiz_answer_values

  field :name, type: String
  field :image_url, type: String
end
