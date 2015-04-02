class Word
  include Mongoid::Document
  include Mongoid::Timestamps

  include SoftRemove

  has_many :seqs, autosave: true
  has_many :entries, autosave: true, dependent: :destroy
  has_many :proposals, dependent: :destroy
  has_many :activities, dependent: :destroy

  validates :entries,
            :associated => true,
            :length => { :minimum => 1 },
            :on => :create

  def self.lookup(name)
    Word.where(name: name).first
  end

  def name
    seqs.first.text
  end

  def name=(text)
    if seqs.count == 0
      seqs.build(text: text)
    else
      seqs.first.update_attributes(text: text)
    end
  end

  def add_meaning(pos, definition, example)
    entry = self.entries.where(pos: pos).first
    if entry.nil?
      entry = self.entries.build(pos: pos)
    end
    entry.meanings.build(def: definition, example: example)
  end

  deprecate :name=
end
