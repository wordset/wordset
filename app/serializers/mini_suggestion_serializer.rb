class MiniSuggestionSerializer < BaseSerializer
  attributes :id, :target_id, :target_type, :word_id, :delta, :user_id, :meaning_id, :action, :state

  def meaning_id
    if object.target.is_a? Meaning
      object.target.id
    else
      nil
    end
  end

  def user_id
    object.user.username
  end
end
