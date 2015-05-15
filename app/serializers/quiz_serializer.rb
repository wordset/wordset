class QuizSerializer < ActiveModel::Serializer
  attributes :id, :slug, :title, :image_url

  def attributes
    h = super
    h['questions'] = object.quiz_questions.map do |question|
      answers = question.quiz_answers.map do |answer|
        {text: answer.text,
         result_values: answer.result_values }
      end
      {text: question.text,
       image: question.image_url,
       answers: answers}
    end
    h['results'] = {}
    object.quiz_results.each do |result|
      h['results'][result.id.to_s] = {name: result.name, image: result.image}
    end
    h
  end
end
