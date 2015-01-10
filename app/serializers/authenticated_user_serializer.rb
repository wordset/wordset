class AuthenticatedUserSerializer < BaseSerializer
  root 'user'
  attributes :id, :email, :auth_key, :username
end
