class WordsetSerializer < BaseSerializer
  attributes :id, :name
  has_many :entries, serializer: EntrySerializer
end
