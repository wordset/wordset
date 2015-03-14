module ProposalActivity
  extend ActiveSupport::Concern

  included do |base|
    base.field :word_name, type: String
    base.belongs_to :proposal
    base.index({proposal_id: 1})

    base.before_create :set_cached_word

  end

  def set_cached_word
    if proposal
      self.word_name = proposal.word_name
    end
    true
  end

  def word=(word)

  end

  deprecate :word=
end
