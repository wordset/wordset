class Notification
  include Mongoid::Document

  belongs_to :activity
  belongs_to :user # This is the notification's target

  validates :user,
            presence: true
  validates :activity,
            presence: true

  after_create :send_push_notification

  def send_push_notification
    Pusher[user.username + '_channel'].trigger('notify', self.to_json)
  end

  def to_json
    NotificationSerializer.new(self).to_json
  end

end
