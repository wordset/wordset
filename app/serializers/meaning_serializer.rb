class MeaningSerializer < BaseSerializer
  attributes :id, :def, :example, :has_proposal

  def has_proposal
    object.proposals.where(state: "open").any?
  end
end
