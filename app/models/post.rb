class Post
  include Mongoid::Document
  include Mongoid::Timestamps

  scope :published, -> { where(:published_at.lt => Time.now) }

  field :title, type: String
  field :slug, type: String
  field :author_name, type: String
  field :text, type: String
  field :published_at, type: Time

  def publish!
    update_attributes(published_at: Time.now)
  end
end
