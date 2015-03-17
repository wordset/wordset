class UserPromotionActivity < Activity
  field :new_level, type: String
  after_create :notify_user!
end
