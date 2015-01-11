FactoryGirl.define do
  factory :word do
    name "hit"
    entries [
      {pos: "v",
       meanings: [
         {def: "to punch"}
         ]}
    ]


  end

  factory :word_list do
  end
end
