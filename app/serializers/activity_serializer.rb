class ActivitySerializer < ActiveModel::Serializer
  attributes :id, :type, :user_id, :created_at

  def type
    object._type[0..-9]
  end

  def user_id
    object.username
  end

  def attributes
    h = super
    modules = object.class.included_modules
    if modules.include?(ProposalActivity)
      h[:word_name] = object.word_name
      h[:proposal_id] = object.proposal.id
    end
    if object.is_a? ProposalClosedActivity
      h["final_state"] = object.final_state
    elsif object.is_a? VoteActivity
      h["vote_value"] = object.vote_value
    elsif object.is_a? ProposalCommentActivity
      h["comment"] = object.comment
    elsif object.is_a? UserPromotionActivity
      h["new_level"] = object.new_level
    elsif object.is_a? UserBadgeActivity
      h["badge"] =  {
        level: object.level,
        display_name: I18n.t("badges.#{object.name}.name")
      }
    end
    h
  end
end
