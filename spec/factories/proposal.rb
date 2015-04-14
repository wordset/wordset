FactoryGirl.define do
  factory :propose_new_meaning do
    user
    wordset
    lang { Lang.first || create(:lang) }
    speech_part { SpeechPart.first || create(:speech_part) }
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
    speech_part { SpeechPart.first || create(:speech_part) }
    self.def { Faker::Lorem.sentence }
    self.example { Faker::Lorem.sentence }
    self.reason { Faker::Lorem.sentence }
  end

  factory :propose_new_wordset do
    user
    lang { Lang.first || create(:lang) }
    name { Faker::Lorem.word + "newmeaningproposal" }
    before(:create) do |proposal, evaluator|
      create_list(:embed_new_word_meaning, 1, propose_new_wordset: proposal)
    end
  end
end
