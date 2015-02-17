class ActivitySerializer < ActiveModel::Serializer
  attributes :id, :comment, :type, :word_id, :user_id, :proposal_id

  def type
    object._type[0..-9]
  end

  def attributes
    h = super
    if object.is_a? ProposalClosedActivity
      h["final_state"] = object.final_state
    end
    h
  end
end
