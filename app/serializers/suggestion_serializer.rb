class SuggestionSerializer < ActiveModel::Serializer
  attributes :id, :target_id, :target_type, :word_id, :delta, :user_id, :meaning_id, :action, :state, :created_at, :wordnet
  has_one :user
  has_one :word
  embed :ids, include: true

  def meaning_id
    if object.target.is_a? Meaning
      object.target.id
    else
      nil
    end
  end

  def user_id
    if !object.wordnet?
      object.user.username
    end
  end
end
