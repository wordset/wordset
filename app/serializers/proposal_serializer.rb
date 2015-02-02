class ProposalSerializer < ActiveModel::Serializer
  attributes :id, :word_id, :delta,
             :target_id, :user_id, :target_type,
             :action, :state, :created_at, :wordnet,
             :meaning_id

  def meaning_id
    if object.target_type == "Meaning"
      object.target_id
    else
      nil
    end
  end

  def user_id
    if object.user
      object.user.username
    else
      nil
    end
  end
end
