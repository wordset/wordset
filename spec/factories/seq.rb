FactoryGirl.define do
  factory :seq do
    text { Faker::Lorem.words(2).join(" ") }
    lang { Lang.first || create(:lang) }
  end
end
