FactoryGirl.define do
  factory :entry do
    pos "noun"
    word

    before(:create) do |entry, evaluator|
      create_list(:meaning, 1, entry: entry)
    end
  end
end
