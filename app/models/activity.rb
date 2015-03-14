class Activity
  include Mongoid::Document
  include Mongoid::Timestamps

  belongs_to :user
  index({user_id: 1})
  field :username, type: String

  index({type: 1})

  index({created_at: -1})

  before_create :set_cached_user
  after_create :push

  def push
    Pusher["activities"].trigger(
     'push',
     ActivitySerializer.new(self).to_json)
  end

  def set_cached_user
    if user
      self.username = user.username
    end
    true
  end

end
