FactoryGirl.define do
  factory :meaning do
    self.def { Faker::Lorem.sentence }
    self.example { Faker::Lorem.sentence }
    entry

    factory :wordnet_meaning do
      wordnet_import true
    end
  end
end
