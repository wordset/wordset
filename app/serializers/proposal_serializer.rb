class ProposalSerializer < ActiveModel::Serializer
  attributes :id, :word_id, :delta,
             :target_id, :target_type,
             :action, :state, :created_at, :wordnet,
             :meaning_id, :parent_id, :pos, :word_name,
             :original, :original_user, :user_id,
             :reason
  has_one :user, embed_key: :to_param
  #has_one :word

  def pos
    if object.target_type == "Meaning"
      object.target.entry.pos
    else
      object.delta["pos"]
    end
  end

  def parent_id
    unless object.create?
      object.proposal_id
    end
  end

  def original
    if !object.create? && object.proposal
      object.proposal.delta
    else
      nil
    end
  end

  def original_user
    if object.proposal && object.proposal.user
      object.proposal.user.username
    else
      nil
    end
  end

  def word_name
    object.word.name
  end

  def meaning_id
    if object.target_type == "Meaning"
      object.target_id
    else
      nil
    end
  end
end
