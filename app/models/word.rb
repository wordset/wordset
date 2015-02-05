class Word
  include Mongoid::Document
  include Mongoid::Timestamps
  field :name
  field :word_length, type: Integer, as: "l"
  has_many :entries, autosave: true
  has_many :proposals

  validates :entries,
            :associated => true,
            :length => { :minimum => 1 },
            :on => :create

  index({:name => 1}, {:unique => true, drop_dups: true})

  before_save do |d|
    d.word_length = d.name.length
  end

  def add_meaning(pos, definition, example)
    entry = self.entries.where(pos: pos).first
    if entry.nil?
      entry = self.entries.build(pos: pos)
    end
    entry.meanings.build(def: definition, example: example)
  end
end
