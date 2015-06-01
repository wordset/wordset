class LangSerializer < BaseSerializer
  attributes :id, :name, :parts, :quizzes_simple, :posts_simple
  has_many :labels, serializer: LabelSerializer
  has_one :project, embed_key: :slug

  def id
    object.code
  end

  def parts
    object.speech_parts.map &:code
  end

  def posts_simple
    object.posts.published.limit(3).map do |p|
      {id: p.slug, title: p.title}
    end
  end

  # Only pass back the active project
  def project
    object.featured_project
  end

  def quizzes_simple
    object.quizzes.published.map do |q|
      {id: q.slug, title: q.title}
    end
  end

end
