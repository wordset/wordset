class UserSerializer < BaseSerializer
  attributes :id, :errors

  def id
    object.username
  end
end
