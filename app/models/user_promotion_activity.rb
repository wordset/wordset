class UserPromotionActivity < Activity
  field :new_level, type: String
  after_create :email_user!

  def email_user!
    NotificationMailer.promoted(self).deliver_now
  end
end
