class User
  include Mongoid::Document
  # Include default devise modules. Others available are:
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
        :trackable, :validatable
         #:confirmable :recoverable, :rememberable,

  field :username, type: String
  index({:username => 1}, {unique: true})
  validates :username, format: { with: /\A\w+\Z/ },
                       length: { minimum: 3, maximum: 16 },
                       uniqueness: true

  ## Database authenticatable
  field :email,              type: String, default: ""
  index :email => 1
  field :encrypted_password, type: String, default: ""

  ## Recoverable
  #field :reset_password_token,   type: String
  #field :reset_password_sent_at, type: Time

  ## Trackable
  field :sign_in_count,      type: Integer, default: 0, as: "sic"
  field :current_sign_in_at, type: Time, as: "csia"
  field :last_sign_in_at,    type: Time, as: "lsia"
  field :current_sign_in_ip, type: String, as: "csii"
  field :last_sign_in_ip,    type: String, as: "lsii"

  ## Confirmable
  #field :confirmation_token,   type: String
  #field :confirmed_at,         type: Time
  #field :confirmation_sent_at, type: Time
  #field :unconfirmed_email,    type: String # Only if using reconfirmable

  # Token
  field :auth_key,  type: String, as: "key"

  before_save :ensure_auth_key

  def ensure_auth_key
    if auth_key.blank?
      self.auth_key = generate_auth_key
    end
  end

  private

  def generate_auth_key
    loop do
      token = Devise.friendly_token
      break token unless User.where(auth_key: token).first
    end
  end


end
