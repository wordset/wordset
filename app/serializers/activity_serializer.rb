class ActivitySerializer < ActiveModel::Serializer
  attributes :id, :comment, :type, :word_id, :user_id, :proposal_id, :created_at

  def type
    object._type[0..-9]
  end

  def user_id
    object.user.username
  end

  def word_id
    if object.word
      object.word.name
    end
  end

  def attributes
    h = super
    if object.is_a? ProposalClosedActivity
      h["final_state"] = object.final_state
    elsif object.is_a? VoteActivity
      h["vote_value"] = object.vote_value
    end
    h
  end
end
