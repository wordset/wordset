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

  scope :needs_emailing, -> { where(state: "unseen", :created_at.lt => 15.minutes.ago) }

  index({state: 1, created_at: 1})
  index({user_id: 1})
  index({state: 1, user_id: 1})

  aasm :column => :state do
    state :unseen, initial: true
    state :seen
    state :email_sent
    state :email_clicked

    state :not_emailed

    event :ack do
      transitions from: [:unseen, :seen], to: :seen
    end

    event :send_email do
      transitions from: :unseen, to: :email_sent
    end

    event :no_email_allowed do
      transitions from: :unseen, to: :not_emailed
    end

    event :clicked_email_link do
      transitions to: :email_clicked
    end
  end

  def check_successful_status
    self.successful = ["seen", "email_clicked"].include?(state)
    true
  end

  def self.send_emails
    sent_count = 0
    unsub_count = 0
    Notification.needs_emailing.group_by(&:user).each do |user, list|
      if user.unsubscribed
        list.each &:no_email_allowed!
        unsub_count += 1
      else
        if list.count == 1
          NotificationMailer.single(list.first).deliver_now!
        else
          NotificationMailer.digest(user, list).deliver_now!
        end
        list.each &:send_email!
        sent_count += list.size
      end
    end

    puts "Sent: #{sent_count}, Unsubscribed Email Ignores: #{unsub_count}"
  end

  def send_push_notification
    Pusher[user.username + '_channel'].trigger('notify', self.to_json)
  end

  def to_json
    NotificationSerializer.new(self).to_json
  end

end
