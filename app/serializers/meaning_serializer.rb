class MeaningSerializer < BaseSerializer
  attributes :id, :def, :example, :has_proposal

  def has_proposal
    !object.open_proposal_id.nil?
  end
end
