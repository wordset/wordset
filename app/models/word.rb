class Word
  include Mongoid::Document
  include Mongoid::Timestamps
  include Editable
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

  def self.editable_fields
    %w(name)
  end

  def self.editable_children
    %w(entries)
  end
end
