class UserSerializer < BaseSerializer
  attributes :id, :points, :image_url, :created_at

  def id
    object.username
  end

  def image_url
    object.gravatar_url
  end
end
