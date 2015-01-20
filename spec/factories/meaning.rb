FactoryGirl.define do
  factory :meaning do
    self.def { Faker::Lorem.sentence }
    entry

    before(:create) do |meaning, evaluator|
      create_list(:quote, 1, meaning: meaning)
    end
  end
end
