class Message
  include Mongoid::Document
  include Mongoid::Timestamps

  belongs_to :user
  index({user_id: 1, created_at: 1})
  index({created_at: -1})

  field :text, type: String

  validates :text,
            :presence => true,
            format: { with: /\A[^\n]+\Z/ }
end
