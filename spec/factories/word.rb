FactoryGirl.define do
  factory :word do
    name { Faker::Lorem.word }

    factory :word_with_entry do
      after(:create) do |word, evaluator|
        create_list(:entries, 1, word: word)
      end

      factory :word_with_meaning do
        after(:create) do |word, evaluator|
          create_list(:meaning, 3, entry: word.entries.first)
        end
      end
    end
  end

  factory :word_list do
  end
end
