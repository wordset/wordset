class VoteActivity < Activity
  include ProposalActivity
  field :vote_value, type: Integer
end
