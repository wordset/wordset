class WordSerializer < BaseSerializer
  attributes :id, :name
  has_many :entries

  #params :hi
end
