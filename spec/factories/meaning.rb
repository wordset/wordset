FactoryGirl.define do
  factory :meaning do
    self.def { Faker::Lorem.sentence }
    entry
  end
end
