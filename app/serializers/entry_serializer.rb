class EntrySerializer < BaseSerializer
  attributes :id, :pos, :wordset_id
  has_many :meanings, serializer: MeaningSerializer

end
