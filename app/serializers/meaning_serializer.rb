class MeaningSerializer < BaseSerializer
  attributes :id, :def, :example, :has_proposal, :open_proposal_id, :wordset_id, :pos
  has_many :labels

  def has_proposal
    !object.open_proposal_id.nil?
  end

  def pos
    object.speech_part.code
  end
end
 
