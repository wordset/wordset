class ProposalClosedActivity < Activity
  include ProposalActivity
  field :final_state, type: String
end
