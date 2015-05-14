class QuizAnswer
  include Mongoid::Document

  embedded_in :quiz_question
  embeds_many :quiz_answer_values

  accepts_nested_attributes_for :quiz_answer_values, allow_destroy: true

  field :text, type: String
  field :result_values, type: Hash


end
