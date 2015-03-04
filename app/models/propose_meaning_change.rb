class ProposeMeaningChange < Proposal
  include MeaningLike #!!!!! LOOK IN MEANING LIKE!
  include MeaningProposalLike #!!!! ALSO HERE.

  def commit!
    meaning.def = self.def
    meaning.example = self.example
    meaning.accepted_proposal = self
    meaning.open_proposal = nil
    meaning.save
    if project
      project_target.complete!
    end
    meaning
  end

  def cleanup_proposal!
    meaning.update_attributes(open_proposal: nil)
    if project
      project_target.restart!
    end
    super
  end



end
