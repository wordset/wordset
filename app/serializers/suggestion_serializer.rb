class SuggestionSerializer < BaseSerializer
  attributes :id, :target_id, :target_type, :word_id, :delta, :user_id, :meaning_id, :quote_id, :action, :state
  #belongs_to :user

  def meaning_id
    if object.target.is_a? Meaning
      object.target.id
    else
      nil
    end
  end

  def quote_id
    if object.target.is_a? Quote
      object.target.id
    else
      nil
    end
  end

  def user_id
    object.user.username
  end
end
