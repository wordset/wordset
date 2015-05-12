FactoryGirl.define do
  factory :lang do
    code :en
    name "English"

    before(:create) do |lang, evaluator|
      create_list(:speech_part, 2, lang: lang)
    end
  end
end
