class ProposalCommentActivity < Activity
  include ProposalActivity

  field :comment, type: String

  after_create :notify_proposal_owner
end
