class MeaningSerializer < BaseSerializer
  attributes :id, :def, :example, :has_proposal, :open_proposal_id, :word_id

  def word_id
    object.word.name
  end

  def has_proposal
    !object.open_proposal_id.nil?
  end
end
