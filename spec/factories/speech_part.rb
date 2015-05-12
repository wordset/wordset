FactoryGirl.define do
  factory :speech_part do
    code { Faker::Lorem.word[0..3] }
    name { Faker::Lorem.word }
    lang { Lang.first || create(:lang) }
  end
end
