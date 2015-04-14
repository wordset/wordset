class WordsetSerializer < BaseSerializer
  attributes :id, :name, :lang_id
  has_many :meanings, serializer: MeaningSerializer

  def lang_id
    object.lang.code
  end
end
