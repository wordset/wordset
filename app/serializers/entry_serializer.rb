class EntrySerializer < BaseSerializer
  attributes :id, :pos
  has_many :meanings, serializer: MeaningSerializer

end
