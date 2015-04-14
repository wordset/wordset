# This class is only used to embed Meanings in a ProposeNewWordsetProposal
class EmbedNewWordMeaning
  include Mongoid::Document
  include MeaningLike
  include PosLike
  embedded_in :propose_new_wordset

  field :reason, type: String

  validates :reason,
            :length => {minimum: 10},
            :presence => true

  def wordnet?
    propose_new_wordset.wordnet?
  end
end
