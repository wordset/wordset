class Activity
  include Mongoid::Document
  include Mongoid::Timestamps

  belongs_to :user
  index({user_id: 1})
  belongs_to :word
  index({word_id: 1})
  belongs_to :proposal
  index({proposal_id: 1})
  index({type: 1})

  index({created_at: -1})

  field :comment, type: String
end
