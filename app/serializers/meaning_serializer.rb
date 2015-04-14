class MeaningSerializer < BaseSerializer
  attributes :id, :def, :example, :has_proposal, :open_proposal_id, :wordset_id

  def has_proposal
    !object.open_proposal_id.nil?
  end
end
