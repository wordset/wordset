class WordSerializer < BaseSerializer
  attributes :id
  has_many :entries, serializer: EntrySerializer

  def id
    object.name
  end
end
