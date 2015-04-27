class SeqSerializer < BaseSerializer
  attributes :id, :text
  has_one :lang, embed_key: :code
  has_one :wordset
  has_many :labels

  def id
    object.key
  end
end
