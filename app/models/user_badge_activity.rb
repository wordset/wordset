class UserBadgeActivity < Activity
  belongs_to :badge
  field :level
  field :name
  field :subject

  after_create :notify_user!

  #def email_user!
  #  NotificationMailer.badged(self).deliver_now
  #end

  # badge :fast_riser do
  #   on :create
  #   condition do |model|
  #     UserPromotionActivity.where(user: model.user)
  #   end
  # end
end
