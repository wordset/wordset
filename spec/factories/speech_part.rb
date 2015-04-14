FactoryGirl.define do
  factory :speech_part do
    code :adj
    name "adjective"
    lang { Lang.first || create(:lang) }
  end
end
