class Word
  include Mongoid::Document
  field :name
  embeds_many :entries, class_name: "WordEntry"

  index({:name => 1}, {:unique => true})
end
