class WordsetSerializer < BaseSerializer
  attributes :id, :name, :lang_id
  has_many :entries, serializer: EntrySerializer

  def lang_id
    object.lang.code
  end
end
