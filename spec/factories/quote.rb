FactoryGirl.define do
  factory :quote do
    text { Faker::Lorem.sentence }
    source { Faker::Name.name }
    url { Faker::Internet.url }
    meaning
  end
end
