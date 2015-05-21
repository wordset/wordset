class PostSerializer < BaseSerializer
  attributes :id, :title, :text, :published_at, :author_name

  def id
    object.slug
  end
end
