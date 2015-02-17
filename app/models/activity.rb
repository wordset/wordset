class Activity
  include Mongoid::Document
  include Mongoid::Timestamps

  belongs_to :user
  belongs_to :word
  belongs_to :proposal

  field :comment, type: String
end
