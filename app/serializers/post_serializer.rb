class PostSerializer < BaseSerializer
  attributes :id, :title, :text, :published_at

  def id
    object.slug
  end
end
