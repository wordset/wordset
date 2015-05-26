class Badge
  include Mongoid::Document
  include Mongoid::Timestamps

  field :name, type: String
  field :subject, type: String
  field :level, type: Integer
  field :has_levels, type: Integer
  belongs_to :project
  has_one :user_badge_activity, dependent: :destroy
  belongs_to :user

  index({user_id: 1, name: 1, subject: 1})

  def notify!
    self.create_user_badge_activity(user: user)
  end

  def description
    t("description")
  end

  def display_name
    t("name")
  end

  def full_name
    if level
      "\"#{display_name}\" Level #{level}"
    else
      display_name
    end
  end

  def image
    "#{self.slug}.png"
  end

  def slug
    "#{self.subject}/#{self.name}"
  end

  def project_slug
    if project
      project.slug
    else
      nil
    end
  end

  def to_data
    {name: self.slug,
     display_name: display_name,
     description: description,
     level: self.level,
     project_id: project_slug
    }
  end

  def t(key)
    I18n.t("badges.#{self.subject}.#{self.name}.#{key}")
  end
end
