FactoryGirl.define do
  factory :quote do
    text { Faker::Lorem.sentence }
    source { Faker::Name.name }
    url { Faker::Internet.url }
    meaning

    factory :wordnet_quote do
      source "Wordnet 3.0"
      url ""
    end
  end
end
