FactoryGirl.define do
  factory :seq do
    text { Faker::Lorem.words(4, true).join("") }
    lang { Lang.first || create(:lang) }
  end
end
