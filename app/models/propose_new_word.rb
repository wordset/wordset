class ProposeNewWord < Proposal
  embeds_many :embed_new_word_meanings

  field :name, type: String

  validates :name,
            presence: true,
            length: { minimum: 1 }

  validates :embed_new_word_meanings,
            associated: true,
            length: { minimum: 1 }

  validate :validate_unique_name,
           on: :create

  def commit!
    word = Word.new(name: name)
    embed_new_word_meanings.each do |meaning|
      meaning = word.add_meaning(meaning.pos, meaning.def, meaning.example)
      meaning.accepted_proposal = self
    end
    word.save!
    self.word = word
    WordList.destroy_all
    word
  end

  # OVERRIDE
  def word_name
    name
  end

  def validate_unique_name
    if !wordnet? && Word.where(name: self.name).any?
      self.errors.add :name, "already exists"
    end
    if ProposeNewWord.where(name: self.name, state: "open").any?
      self.errors.add :name, "already has a proposal open"
    end
  end


end
