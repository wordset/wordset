class Badge
  include Mongoid::Document
  include Mongoid::Timestamps

  field :name, type: String
  field :subject, type: String
  field :level, type: Integer
  field :has_levels, type: Integer
  has_one :user_badge_activity, dependent: :destroy
  embedded_in :badgeable, polymorphic: true

  def notify!
    self.create_user_badge_activity(user: badgeable,
                                    level: self.level,
                                    name: self.name,
                                    subject: self.subject)

  end

  def to_data
    {name: self.name,
     display_name: I18n.t("badges.#{self.name}.name"),
     description: I18n.t("badges.#{self.name}.description"),
     level: self.level,
     subject: self.subject}
  end
end
