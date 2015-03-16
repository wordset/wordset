class Notification
  include Mongoid::Document
  include Mongoid::Timestamps
  include AASM

  belongs_to :activity
  belongs_to :user # This is the notification's target
  field :state, type: String

  # Whenever an event or state happens that means that the
  # user interacted with it, of any type, we will set this to true
  # Non-successful means it was either unopened or just archived or ignored.
  field :successful, type: Boolean, default: false

  validates :user,
            presence: true
  validates :activity,
            presence: true

  after_create :send_push_notification
  before_save :check_successful_status


  index({state: 1, created_at: 1})
  index({user_id: 1})
  index({state: 1, user_id: 1})

  aasm :column => :state do
    state :unseen, initial: true
    state :seen
    state :email_sent
    state :email_read
    state :email_clicked

    event :ack do
      transitions from: [:unseen, :seen], to: :seen
    end

    event :send_email, before: :process_email do
      transitions from: :unseen, to: :email_sent
    end
  end

  def check_successful_status
    self.successful = ["seen", "email_read", "email_clicked"].include?(state)
    true
  end

  def send_push_notification
    Pusher[user.username + '_channel'].trigger('notify', self.to_json)
  end

  def to_json
    NotificationSerializer.new(self).to_json
  end

  def process_email
    #TODO send email
  end

end
