class UserSerializer < BaseSerializer
  attributes :id, :points, :image_url, :trust_level, :created_at, :badges

  def id
    object.username
  end

  def image_url
    object.gravatar_url
  end

  def trust_level
    object.trust_level_data[:name]
  end

  def badges
    object.badges.map &:to_data
  end

end
