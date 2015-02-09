class UserSerializer < BaseSerializer
  attributes :id, :points, :image_url, :rank, :created_at

  def id
    object.username
  end

  def image_url
    object.gravatar_url
  end

  def rank
    object.rank[:name]
  end

end
