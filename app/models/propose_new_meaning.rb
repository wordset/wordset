class ProposeNewMeaning < Proposal
  include MeaningLike
  include PosLike

  before_create :set_original

  def commit!
    meaning = wordset.add_meaning(speech_part, self.def, example)
    meaning.accepted_proposal_id = self.id
    wordset.save!
    meaning.save!
    meaning
  end

  def set_original
    entry = wordset.entries.where(pos: pos).first
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
