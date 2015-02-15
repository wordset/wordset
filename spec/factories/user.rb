FactoryGirl.define do
  factory :user do
    username { Faker::Lorem.characters(10) }
    email { Faker::Internet.safe_email }
    password "testtest"
    password_confirmation "testtest"
    email_opt_in_at Time.now
    email_opt_in_ip "127.0.0.1"
    accept_tos_at Time.now
    accept_tos_ip "127.0.0.1"
  end
end
