class LangSerializer < BaseSerializer
  attributes :id, :name, :parts

  def id
    object.code
  end

  def parts
    object.speech_parts.map &:code
  end

end
