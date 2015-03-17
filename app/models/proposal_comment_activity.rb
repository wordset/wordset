class ProposalCommentActivity < Activity
  include ProposalActivity

  field :comment, type: String

  after_create :notify_not_me

  def notify_not_me
    if self.user != self.proposal.user
      notify_proposal_owner
    end
  end

end
