class Meaning
  include Mongoid::Document
  include MeaningLike #!!!!! LOOK IN MEANING LIKE!
  include SoftRemove
  field :wordnet_import, type: Boolean, default: false

  belongs_to :open_proposal, class_name: "Proposal"
  belongs_to :accepted_proposal, class_name: "Proposal" # last accepted proposal
  belongs_to :speech_part
  belongs_to :wordset

  has_many :proposals, inverse_of: :meaning, class_name: "ProposeMeaningChange"
  has_many :project_targets

  index({removed_at: 1, "_id": 1})
  index({entry_id: 1})
  index({removed_at: 1, wordset_id: 1})

  set_callback :remove, :after do |meaning|
    if meaning.wordset.meanings.count == 0
      meaning.wordset.remove!
    end
    # Make sure we invalidate our targets
    project_targets.each do |target|
      target.meaning_deleted!
    end

  end

  def wordset_id
    wordset.id
  end

  def wordnet?
    wordnet_import?
  end

end
