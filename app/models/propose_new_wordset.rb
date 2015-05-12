class ProposeNewWordset< Proposal
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
    wordset = Wordset.new
    embed_new_word_meanings.each do |meaning|
      meaning = wordset.add_meaning(lang.speech_parts.where(code: meaning.pos).first, meaning.def, meaning.example, meaning.labels)
      meaning.accepted_proposal = self
    end
    wordset.lang = self.lang
    wordset.save!
    Seq.create(lang: self.lang, text: name, wordset: wordset)
    self.wordset = wordset
    WordList.destroy_all
    wordset
  end

  def cache_word_name!
    self.word_name = name
  end

  def validate_unique_name
    if !wordnet? && Seq.where(text: self.name, lang: self.lang, :wordset_id.ne => nil).any?
      self.errors.add :name, "already exists"
    end
    if ProposeNewWordset.where(name: self.name, lang: self.lang, state: "open").any?
      self.errors.add :name, "already has a proposal open"
    end
  end


end
