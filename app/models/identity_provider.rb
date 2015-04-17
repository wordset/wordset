class IdentityProvider
  include Mongoid::Document
  include Mongoid::Timestamps

  field :name, type: String

  has_many :identities

  def find_with_token(token)
    identity = identities.where(token: token).first
    if identity.nil? || identity.expired?
      return nil
    else
      return identity
    end
  end
end
