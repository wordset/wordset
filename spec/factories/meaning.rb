FactoryGirl.define do
  factory :meaning do
    self.def { Faker::Lorem.sentence }
    self.example { Faker::Lorem.sentence }
    speech_part { SpeechPart.first || create(:speech_part) }
    wordset

    factory :wordnet_meaning do
      wordnet_import true
    end
  end
end
