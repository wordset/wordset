class UserSerializer < BaseSerializer
  attributes :id, :points

  def id
    object.username
  end
end
