class VoteSerializer < BaseSerializer
  attributes :id, :proposal_id, :user_id, :yae, :value

  def user_id
    object.user.username
  end
  
end
