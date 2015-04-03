FactoryGirl.define do
  factory :propose_new_meaning do
    user
    word
    lang { Lang.first || create(:lang) }
    pos "noun"
    self.def "The sport of jsaialai"
    self.example "I love playing jsaialai."
    factory :open_proposal do
      state "open"
    end
    factory :closed_proposal do
      state "rejected"
    end
  end
end
