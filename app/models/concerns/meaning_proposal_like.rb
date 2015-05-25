module MeaningProposalLike
  extend ActiveSupport::Concern

  included do |base|
    base.before_create :set_before_create
    base.after_create  :set_proposal
    base.after_create  :update_project_target
    base.belongs_to :meaning
    base.belongs_to :project

    base.validates :meaning,
                   :presence => true

    base.validate :no_existing_proposal,
               on: :create
    base.validate :ensure_project_target_todo,
               on: :create

    base.index({meaning_id: 1})
    base.index({_type: 1, meaning_id: 1})

    base.badge :british_label do
      on :after_proposal_committed
      subject_name :proposals
      condition do |model|
        if model.user && model.respond_to?(:labels)
          model.labels.where(id: Label.where(name: "British").first.try(:id)).any?
        else
          false
        end
      end
    end

    base.badge :american_label do
      on :after_proposal_committed
      subject_name :proposals
      condition do |model|
        if model.user && model.respond_to?(:labels)
          model.labels.where(id: Label.where(name: "American").first.try(:id)).any?
        else
          false
        end
      end
    end
  end

  def set_before_create
    self.wordset = meaning.wordset
    self.word_name = wordset.name
    self.original = {def: meaning.def,
                     example: meaning.example,
                     pos: meaning.speech_part.code,
                     labels: (meaning.labels.map &:id) }
  end

  def set_proposal
    meaning.open_proposal = self
    meaning.save
  end

  def update_project_target
    if project
      project_target.open_proposal!
    end
  end

  def project_target
    ProjectTarget.where(meaning: meaning, project: project).first
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
