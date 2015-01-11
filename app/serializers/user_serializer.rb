class UserSerializer < BaseSerializer
  attributes :id

  def id
    object.username
  end
end
