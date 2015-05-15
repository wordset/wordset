class QuizSerializer < ActiveModel::Serializer
  attributes :id, :title, :image_url, :instructions

  def id
    object.slug
  end

  def image_url
    object.image.url
  end

  def attributes
    h = super
    qid = -1
    h['questions'] = object.quiz_questions.map do |question, index|
      aid = -1
      qid += 1
      answers = question.quiz_answers.map do |answer|
        aid += 1
        results = answer.result_values.inject({}) { |h, (k, v)| h[k] = v.to_i; h }
        {text: answer.text,
         result_values: results,
         aid: "#{qid}-#{aid}"}
      end

      {text: question.text,
       image_url: question.image.url,
       answers: answers,
       qid: qid}
    end
    h['results'] = {}
    object.quiz_results.each do |result|
      h['results'][result.id.to_s] = {name: result.name, image_url: result.image.url}
    end
    h
  end
end
