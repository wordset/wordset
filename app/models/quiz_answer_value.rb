class QuizAnswerValue
  include Mongoid::Document

  embedded_in :quiz_answer
  belongs_to :result

  field :value, type: Integer
  field :result_values, type: Hash
end
