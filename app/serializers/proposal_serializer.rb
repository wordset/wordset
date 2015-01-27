class ProposalSerializer < ActiveModel::Serializer
  attributes :id, :word_id, :delta, :target_id, :user_id, :target_type, :action, :state, :created_at, :wordnet, :proposal_id
  has_one :word
  #has_one :proposal

  def meaning
    object.target
  end

  def user_id
    if object.user
      object.user.username
    else
      nil
    end
  end
end
