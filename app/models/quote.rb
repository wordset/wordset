
class Quote
  include Mongoid::Document
  include Suggestable
  field :text, type: String
  field :source, type: String
  field :url, type: String
  belongs_to :meaning

  validates :text,
           :presence => true,
           :length => {:in => 15..200}

  validates :url,
            :url => true,
            :unless => Proc.new { |q| q.source == "Wordnet 3.0"}

  validates :meaning,
            :presence => true,
            :associated => true

  def word
    meaning.word
  end

  def self.suggestable_fields
    %(text source url)
  end


end
