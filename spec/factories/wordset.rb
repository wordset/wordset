FactoryGirl.define do
  factory :wordset do
    before(:create) do |word, evaluator|
      create_list(:entry, 1, word: word)
      create_list(:seq, 1, word: word)
    end

  end

  factory :word_list do
  end
end
