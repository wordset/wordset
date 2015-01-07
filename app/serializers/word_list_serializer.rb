class WordListSerializer < BaseSerializer
  attributes :id, :results

  def id
    object.term
  end

  def results
    object.words.map do |word|
      {name: word.name, word_id: word._id}
    end
  end
end
