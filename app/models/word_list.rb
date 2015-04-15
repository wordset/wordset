class WordList
  include Mongoid::Document
  field :term, type: String
  field :words, type: Array
  index({term: 1}, {unique: true})

  def self.search(term)
    wl = WordList.where({term: term}).first
    if wl == nil
      wl = WordList.new(term: term)
      escaped = Regexp.escape(term)
      wl.words = Seq.limit(20).where({ :text => /^#{escaped}.*/i, :wordset_id.ne => nil }).sort("word_length" => 1).map &:text
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
