class ProposeMeaningChange < Proposal
  include MeaningLike #!!!!! LOOK IN MEANING LIKE!

  belongs_to :meaning

  validates :meaning,
            :associated => true,
            :presence => true

  index({meaning_id: 1})
  index({_type: 1, meaning_id: 1})

  before_create :set_word_before_create
  after_create :set_meaning_proposal

  def commit!
    meaning.def = self.def
    meaning.example = self.example
    meaning.accepted_proposal = self
    meaning.open_proposal = nil
    meaning.save
    meaning
  end

  def set_word_before_create
    self.word = meaning.word
  end

  def set_meaning_proposal
    self.meaning.open_proposal = self
    self.meaning.save
  end
end
