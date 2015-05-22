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

  def badge_display_name
    I18n.t("badges.#{self.name}.name")
  end

  def badge_full_name
    if level
      "\"#{badge_display_name}\" Level #{level}"
    else
      badge_display_name
    end
  end

  def badge_description
    I18n.t("badges.#{self.name}.description")
  end

  def badge_image
    "#{self.name}.svg"
  end
end
