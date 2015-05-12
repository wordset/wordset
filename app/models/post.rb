class Post
  include Mongoid::Document
  include Mongoid::Timestamps

  field :title, type: String
  field :slug, type: String
  field :author_name, type: String
  field :text, type: String
  field :published_at, type: Time

  aasm :column => :state do
    state :draft, initial: true
    state :rejected
    state :published

    event :publish, before: :set_published_at do
      transitions from: :draft, to: :published
    end

    event :reject do
      transitions from: :draft, to: :published
    end
  end

  def set_published_at
    update_attributes(published_at: Time.now)
  end
end
