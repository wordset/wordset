class SeqSerializer < BaseSerializer
  attributes :id
  has_one :wordset

  def id
    object.key
  end
end
