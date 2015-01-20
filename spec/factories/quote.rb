FactoryGirl.define do
  factory :quote do
    text { Faker::Lorem.sentences }
    source "Hampton Catlin"
    url "http://www.hamptoncatlin.com"
    meaning

    factory :wordnet_quote do
      source "Wordnet 3.0"
      url ""
    end
  end
end
