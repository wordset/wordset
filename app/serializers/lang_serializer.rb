class LangSerializer < BaseSerializer
  attributes :id, :name, :parts, :quizzes_simple
  has_many :labels, serializer: LabelSerializer

  def id
    object.code
  end

  def parts
    object.speech_parts.map &:code
  end

  def quizzes_simple
    object.quizzes.published.map do |q|
      {quiz_id: q.slug, title: q.title}
    end
  end

end
