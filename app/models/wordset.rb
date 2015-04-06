class Wordset
  include Mongoid::Document
  include Mongoid::Timestamps
  store_in collection: "words"

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
    seq = Seq.where(text: name).first.try(:word)
  end

  set_callback :remove, :after do |wordset|
    wordset.seqs.update_all(wordset_id: nil)
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
