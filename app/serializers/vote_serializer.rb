class VoteSerializer < BaseSerializer
  attributes :id, :proposal_id, :yae, :value, :comment, :usurped
  has_one :user, embed_key: :to_param

  def user_id
    object.user.username
  end

end
