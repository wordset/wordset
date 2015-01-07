class WordEntrySerializer < BaseSerializer
  attributes :id, :pos
  has_many :meanings
end
