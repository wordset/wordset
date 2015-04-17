class User
  include Mongoid::Document
  include Gravtastic
  include Mongoid::Timestamps
  include TrustLevel # This is all the stuff with user trust_level names and points
  is_gravtastic
  has_many :proposals
  has_many :votes
  has_many :messages
  has_many :activities
  has_many :notifications
  has_many :identities

  # Include default devise modules. Others available are:
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
        :trackable, :validatable, :recoverable
         #:confirmable :recoverable, :rememberable,

  field :username, type: String
  index({:username => 1}, {unique: true})
  validates :username, format: { with: /\A\w+\Z/ },
                       length: { minimum: 3, maximum: 16 },
                       uniqueness: true

  field :unsubscribed, type: Boolean, default: false

  ## Database authenticatable
  field :email,              type: String, default: ""
  index({:email => 1}, {unique: true})
  field :encrypted_password, type: String, default: ""

  ## Recoverable
  field :reset_password_token,   type: String
  field :reset_password_sent_at, type: Time

  ## Trackable
  field :sign_in_count,      type: Integer, default: 0, as: "sic"
  field :current_sign_in_at, type: Time, as: "csia"
  field :last_sign_in_at,    type: Time, as: "lsia"
  field :current_sign_in_ip, type: String, as: "csii"
  field :last_sign_in_ip,    type: String, as: "lsii"

  field :last_seen_at,       type: Time, as: "lsa"
  index({:last_seen_at => -1})

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
  after_create :add_to_mailchimp

  def ensure_auth_key
    if auth_key.blank?
      self.auth_key = generate_auth_key
    end
  end

  def recalculate_points!
    proposals = self.proposals.where(state: "accepted").count
    votes = self.votes.ne(skip: true).count
    self.points = (proposals*10) + votes
  end

  def voted_proposal_ids
    #Mongoid::Sessions.default[:votes].find(user_id: current_user.id).select(proposal_id: 1).to_a
    self.votes.where(usurped: false).map &:proposal_id
  end

  def self.online_usernames
    self.gt(last_seen_at: 10.minutes.ago).order(:last_seen_at.desc).pluck(:username)
  end

  def add_to_mailchimp
    if Rails.env == "production" && email_opt_in_at
      Mailchimp.lists.subscribe({id: WordsetListId, email: {email: self.email}, :double_optin => false})
    end
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
