class ProposeNewMeaning < Proposal
  include MeaningLike
  include PosLike

  before_create :set_original

  def commit!
    meaning = word.add_meaning(pos, self.def, example)
    meaning.accepted_proposal_id = self.id
    word.save!
    meaning.save!
    meaning
  end

  def set_original
    entry = word.entries.where(pos: pos).first
    if entry.nil?
      self.original = {}
    else
      meanings = entry.meanings.collect do |meaning|
        { def: meaning.def, example: meaning.example }
      end
      self.original = { meanings: meanings }
    end
  end

end
