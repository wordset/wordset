class Post
  include Mongoid::Document
  include Mongoid::Timestamp

  field :title, type: String
  field :slug, type: String
  field :text, type: String
  field :published_at, type: Time
end
