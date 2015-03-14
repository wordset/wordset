class ProposalClosedActivity < Activity
  include ProposalActivity
  field :final_state, type: String

  after_create :notify_proposal_owner

end
