FactoryGirl.define do
  factory :word do
    name { Faker::Lorem.word }


    before(:create) do |word, evaluator|
      create_list(:entry, 1, word: word)
    end

  end

  factory :word_list do
  end
end
