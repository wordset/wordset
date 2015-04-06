class Meaning
  include Mongoid::Document
  include MeaningLike #!!!!! LOOK IN MEANING LIKE!
  include SoftRemove
  field :wordnet_import, type: Boolean, default: false

  belongs_to :entry
  belongs_to :open_proposal, class_name: "Proposal"
  belongs_to :accepted_proposal, class_name: "Proposal" # last accepted proposal

  has_many :proposals, inverse_of: :meaning, class_name: "ProposeMeaningChange"
  has_many :project_targets

  validates :entry,
            :presence => true

  index({entry_id: 1})
  index({removed_at: 1, entry_id: 1})

  set_callback :remove, :after do |meaning|
    if meaning.entry.meanings.count == 0
      meaning.entry.remove!
    end
  end

  def wordset
    entry.wordset
  end

  def wordnet?
    wordnet_import?
  end

end
