class Word
  include Mongoid::Document
  include Mongoid::Timestamps
  include AnagramHelpers
  include ProperNounDestroyer
  include SoftRemove

  field :name
  field :word_length, type: Integer, as: "l"

  has_many :entries, autosave: true, dependent: :destroy
  has_many :proposals, dependent: :destroy
  has_many :activities, dependent: :destroy

  validates :name, :format => { with: /\A[a-zA-Z][a-zA-Z\d\/\-' .]*\z/ } #'

  validates :entries,
            :associated => true,
            :length => { :minimum => 1 },
            :on => :create

  index({:name => 1, removed_at: 1}, {:unique => true, drop_dups: true})
  index({word_length: 1, removed_at: 1})
  index({name: 1, word_length: 1, removed_at: 1})
  index({alpha: 1, removed_at: 1})
  index({name: 1, removed_at: 1})

  before_save do |d|
    d.word_length = d.name.length
  end

  def self.lookup(name)
    Word.where(name: name).first
  end

  def add_meaning(pos, definition, example)
    entry = self.entries.where(pos: pos).first
    if entry.nil?
      entry = self.entries.build(pos: pos)
    end
    entry.meanings.build(def: definition, example: example)
  end
end
