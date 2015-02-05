class ProposeNewWord < Proposal
  embeds_many :embed_new_word_meanings

  field :name, type: String

  validates :name,
            presence: true,
            length: { minimum: 1 }

  validates :embed_new_word_meanings,
            associated: true,
            length: { minimum: 1 }

  validate :validate_unique_name

  def commit!
    word = Word.new(name: name)
    embed_new_word_meanings.each do |meaning|
      meaning = word.add_meaning(meaning.pos, meaning.def, meaning.example)
      meaning.accepted_proposal = self
    end
    word.save
    word
  end

  def validate_unique_name
    if Word.where(name: self.name).any?
      self.errors.add :name, "already exists"
    end
  end


end
