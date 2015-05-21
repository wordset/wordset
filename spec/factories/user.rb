FactoryGirl.define do
  factory :user do
    sequence(:username) { |n| Faker::Lorem.characters(10) + n.to_s }
    sequence(:email) { |n| n.to_s + Faker::Internet.safe_email }
    password "testtest"
    password_confirmation "testtest"
    email_opt_in_at Time.now
    email_opt_in_ip "127.0.0.1"
    accept_tos_at Time.now
    accept_tos_ip "127.0.0.1"
  end
end
