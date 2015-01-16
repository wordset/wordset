FactoryGirl.define do
  factory :word do
    name { Faker::Lorem.word }
    entries {
        (Word.pos.map do |pos|
          if rand(2) == 1
            meanings = []
            (rand(3) + 1).times do
              meanings << {
                def: Faker::Lorem.sentence
              }
            end
            {pos: pos,
              meanings: meanings}
          end
        end).compact
    }
  end

  factory :word_list do
  end
end
