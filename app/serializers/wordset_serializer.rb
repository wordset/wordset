class WordsetSerializer < BaseSerializer
  attributes :id
  has_many :entries, serializer: EntrySerializer
end
