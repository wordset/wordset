# This class is only used to embed Meanings in a ProposeNewWord Proposal
class EmbedNewWordMeaning
  include Mongoid::Document
  include MeaningLike
  include PosLike
  embedded_in :propose_new_word

  field :reason, type: String

  validates :reason,
            :length => {minimum: 10},
            :presence => true

  def wordnet?
    propose_new_word.wordnet?
  end
end
