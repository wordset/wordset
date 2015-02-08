FactoryGirl.define do
  factory :user do
    username { Faker::Lorem.characters(10) }
    email { Faker::Internet.safe_email }
    password "testtest"
    password_confirmation "testtest"
  end
end
