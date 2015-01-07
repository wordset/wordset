class Word
  include Mongoid::Document
  field :name
  field :word_length, type: Integer, as: "l"
  embeds_many :entries, class_name: "WordEntry"

  before_save do |d|
    d.word_length = d.name.length
  end

  index({:name => 1}, {:unique => true})
end
