class ProposeMeaningChange < Proposal
  include MeaningLike #!!!!! LOOK IN MEANING LIKE!

  belongs_to :meaning
  belongs_to :proposal

  validates :meaning,
            :associated => true,
            :presence => true

  field :original, type: Hash

  index({meaning_id: 1})
  index({_type: 1, meaning_id: 1})

  before_create :set_before_create
  after_create :set_meaning_proposal

  def commit!
    meaning.def = self.def
    meaning.example = self.example
    meaning.accepted_proposal = self
    meaning.open_proposal = nil
    meaning.save
    meaning
  end

  def set_before_create
    self.word = meaning.word
    self.original = {def: meaning.def,
                     example: meaning.example,
                     pos: meaning.entry.pos}
  end

  def set_meaning_proposal
    self.meaning.open_proposal = self
    self.meaning.save
  end
end
