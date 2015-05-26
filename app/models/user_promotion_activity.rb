class UserPromotionActivity < Activity
  field :new_level, type: String
  after_create :email_user!

  def email_user!
    NotificationMailer.promoted(self).deliver_now
  end

  def digest_importance
    1
  end

  # badge :fast_riser do
  #   on :create
  #   condition do |model|
  #     UserPromotionActivity.where(user: model.user)
  #   end
  # end
end
