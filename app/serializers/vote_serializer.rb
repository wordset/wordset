class VoteSerializer < BaseSerializer
  attributes :id, :proposal_id, :yae, :value, :usurped, :withdrawn, :skip, :user_id

  def user_id
    object.user.username
  end

end
