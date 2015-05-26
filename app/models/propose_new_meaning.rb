class ProposeNewMeaning < Proposal
  include MeaningLike
  include LabelBadges

  belongs_to :speech_part
  validates  :speech_part,
             :presence => true

  before_create :set_original

  def commit!
    meaning = wordset.add_meaning(speech_part, self.def, example, labels)
    meaning.accepted_proposal_id = self.id
    wordset.save!
    meaning.save!
    meaning
  end

  def set_original
    meanings = wordset.meanings.where(speech_part: speech_part)

    data = meanings.collect do |meaning|
      { def: meaning.def, example: meaning.example }
    end
    self.original = { meanings: data }
  end

end
