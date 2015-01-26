class WordList
  include Mongoid::Document
  field :term
  has_and_belongs_to_many :words, inverse_of: nil
  index({term: 1}, {unique: true})

  def self.search(term)
    wl = WordList.where({term: term}).first
    if wl == nil
      wl = WordList.new(term: term)
      wl.words = Word.limit(20).where({ :name => /^#{term}.*/i }).sort("word_length" => 1).to_a
      wl.save
    end
    wl
  end

  def self.starter_pack
    #WordList.destroy_all
    if WordList.count < 26
      ("a".."z").each do |letter|
        search(letter)
      end
    end
    WordList.where("this.term.length < 2").limit(676)
  end
end
