class Word
  include Mongoid::Document
  include Mongoid::Timestamps
  field :name
  field :word_length, type: Integer, as: "l"
  has_many :entries

  before_save do |d|
    d.word_length = d.name.length
  end

  index({:name => 1}, {:unique => true, drop_dups: true})
end
