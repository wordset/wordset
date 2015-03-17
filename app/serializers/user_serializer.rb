class UserSerializer < BaseSerializer
  attributes :id, :points, :image_url, :trust_level, :created_at

  def id
    object.username
  end

  def image_url
    object.gravatar_url
  end

  def trust_level
    object.trust_level_data[:name]
  end

end
