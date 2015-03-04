class ProposeMeaningRemoval < Proposal
  include MeaningProposalLike #!!!! LOOK HERE

  def commit!
    meaning.update_attributes(open_proposal: nil)
    meaning.remove!
    if project
      project_target.complete!
    end
  end

  def cleanup_proposal!
    meaning.update_attributes(open_proposal: nil)
    if project
      project_target.complete!
    end
    super
  end
end
