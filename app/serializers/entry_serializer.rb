class EntrySerializer < BaseSerializer
  attributes :id, :pos
  has_many :meanings

  #params :hi
end
