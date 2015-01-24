class WordSerializer < BaseSerializer
  attributes :id, :name
  has_many :entries, serializer: EntrySerializer
  has_many :suggestions, serializer: MiniSuggestionSerializer

  #params :hi
end
