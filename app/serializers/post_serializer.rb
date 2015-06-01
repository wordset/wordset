class PostSerializer < BaseSerializer
  attributes :id, :title, :text, :published_at, :author_name, :lang_id

  def id
    object.slug
  end
end
