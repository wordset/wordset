class User
  include Mongoid::Document
  include Gravtastic
  include Mongoid::Timestamps
  include Ranks # This is all the stuff with user rank names and points
  is_gravtastic
  has_many :proposals
  has_many :votes

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
  index({:email => 1}, {unique: true})
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

  ## For Registration Only
  field :email_opt_in_at, type: Time
  field :email_opt_in_ip, type: String
  field :accept_tos_at,   type: Time
  field :accept_tos_ip,   type: String
  validates :accept_tos_at,
            presence: true,
            on: :create
  validates :accept_tos_ip,
            presence: true,
            on: :create


  field :points, type: Integer, default: 0

  index points: 1

  before_save :ensure_auth_key

  def ensure_auth_key
    if auth_key.blank?
      self.auth_key = generate_auth_key
    end
  end

  def recalculate_points!
    proposals = self.proposals.where(state: "accepted").count
    votes = self.votes.count
    self.points = (proposals*10) + votes
  end

  def voted_proposal_ids
    #Mongoid::Sessions.default[:votes].find(user_id: current_user.id).select(proposal_id: 1).to_a
    self.votes.map &:proposal_id
  end

  private

  def generate_auth_key
    loop do
      token = Devise.friendly_token
      break token unless User.where(auth_key: token).first
    end
  end

  def to_param
    self.username
  end
end
