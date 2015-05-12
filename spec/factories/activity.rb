FactoryGirl.define do
  factory :proposal_closed_activity do
    user
    association :proposal, factory: :propose_new_meaning
    final_state "accepted"
  end

  factory :proposal_comment_activity do
    user
    comment "Hello"
    association :proposal, factory: :propose_new_meaning
  end
end
