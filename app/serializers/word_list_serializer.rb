class WordListSerializer < BaseSerializer
  attributes :id, :results

  def id
    object.term
  end

  def results
    object.words.map &:name
  end
end
