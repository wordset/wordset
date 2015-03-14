FactoryGirl.define do
  factory :proposal_closed_activity do
    user
    association :proposal, factory: :propose_new_meaning
    final_state "accepted"
  end
end
