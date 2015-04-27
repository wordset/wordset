class LangSerializer < BaseSerializer
  attributes :id, :name, :parts
  has_many :labels, serializer: LabelSerializer

  def id
    object.code
  end

  def parts
    object.speech_parts.map &:code
  end

end
