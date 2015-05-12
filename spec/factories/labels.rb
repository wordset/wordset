FactoryGirl.define do
  factory :label do
    name { Faker::Lorem.word }
    lang { Lang.first || create(:lang) }
  end
end
