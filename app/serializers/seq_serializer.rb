class SeqSerializer < BaseSerializer
  attributes :id, :text
  has_one :lang, embed_key: :code
  has_one :wordset

  def id
    object.key
  end
end
