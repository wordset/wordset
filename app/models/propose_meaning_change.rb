class ProposeMeaningChange < Proposal
  include MeaningLike #!!!!! LOOK IN MEANING LIKE!

  belongs_to :meaning
  belongs_to :proposal

  validates :meaning,
            :associated => true,
            :presence => true
  validate :no_existing_proposal,
           on: :save
  validate :ensure_project_target_todo

  index({meaning_id: 1})
  index({_type: 1, meaning_id: 1})

  before_create :set_before_create
  after_create :set_meaning_proposal
  after_create :update_project_target

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

  def cleanup_proposal!
    meaning.update_attributes(open_proposal: nil)
    if project
      project_target.restart!
    end
    super
  end

  def project_target
    ProjectTarget.where(meaning: meaning, project: project).first
  end

  def update_project_target
    if project
      project_target.open_proposal!
    end
  end

  def no_existing_proposal
    if meaning.open_proposal
      self.errors.add :meaning, "already has an open proposal"
    end
  end

  def ensure_project_target_todo
    if project && !project_target.todo?
      self.errors.add :project_target, "is either pending or fixed"
    end
  end

end
