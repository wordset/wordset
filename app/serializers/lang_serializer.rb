class LangSerializer < BaseSerializer
  attributes :id

  def id
    object.code
  end
end
