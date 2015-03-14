class Notification
  include Mongoid::Document

  belongs_to :activity
  belongs_to :user # This is the notification's target

end
