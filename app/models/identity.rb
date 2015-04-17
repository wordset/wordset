class Identity
  include Mongoid::Document
  include Mongoid::Timestamps

  field :token, type: String
  field :expires_at, type: Time
  field :data, type: Hash
  field :image_url, type: String # Populate this if we can

  belongs_to :identity_provider
  belongs_to :user

  def expired?
    !expires_at.nil? && (expires_at < Time.now)
  end
end
