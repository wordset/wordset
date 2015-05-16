class QuizAnswer
  include Mongoid::Document

  embedded_in :quiz_question

  field :text, type: String
  validates :text, presence: true
  field :result_values, type: Hash, default: {}
end
