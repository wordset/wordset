class Word
  include Mongoid::Document
  include Mongoid::Timestamps
  field :name
  field :word_length, type: Integer, as: "l"
  has_many :entries, autosave: true
  has_many :proposals

  validates :name, :format => { with: /\A[a-zA-Z][a-zA-Z\d\/\-' .]*\z/ }

  validates :entries,
            :associated => true,
            :length => { :minimum => 1 },
            :on => :create

  index({:name => 1}, {:unique => true, drop_dups: true})
  index({word_length: 1})

  before_save do |d|
    d.word_length = d.name.length
  end

  def self.lookup(name)
    Word.where(name: name).first
  end

  def self.cleanup
    Word.each do |w|
      if !w.valid?
        if w.name.include?("(")
          w.name = w.name.gsub(/\([a-z]+\)/, "")
        end
        if w.valid?
          puts "Fixed to #{w.name}"
          begin
            w.save
          rescue Moped::Errors::OperationFailure
            o = Word.where(name: w.name).first
            w.entries.each do |entry|
              puts "Duplicate, so moving entries"
              entry.update_attributes(:word_id => o.id)
            end
            w.reload
            w.destroy
          end
        else
          puts "DELETED #{w.name}"
          w.destroy
        end
      end
    end
  end

  def add_meaning(pos, definition, example)
    entry = self.entries.where(pos: pos).first
    if entry.nil?
      entry = self.entries.build(pos: pos)
    end
    entry.meanings.build(def: definition, example: example)
  end
end
