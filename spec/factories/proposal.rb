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

  factory :embed_new_word_meaning do
    pos "noun"
    self.def { Faker::Lorem.sentence }
    self.example { Faker::Lorem.sentence }
    self.reason { Faker::Lorem.sentence }
  end

  factory :propose_new_word do
    user
    lang { Lang.first || create(:lang) }
    name { Faker::Lorem.word + "newmeaningproposal" }
    before(:create) do |proposal, evaluator|
      create_list(:embed_new_word_meaning, 1, propose_new_word: proposal)
    end
  end
end
