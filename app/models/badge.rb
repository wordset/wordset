class Badge
  include Mongoid::Document
  include Mongoid::Timestamps

  field :name, type: String
  field :subject, type: String
  field :level, type: Integer
  has_one :user_badge_activity, dependent: :destroy
  embedded_in :badgeable, polymorphic: true

  def notify!
    self.create_user_badge_activity(user: badgeable,
                                    level: self.level,
                                    name: self.name,
                                    subject: self.subject)

  end
end
