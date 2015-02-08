FactoryGirl.define do
  factory :vote do
    proposal
    user
    yae true
    flagged false
  end
end
