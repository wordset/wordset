class Activity
  include Mongoid::Document
  include Mongoid::Timestamps

  belongs_to :user
  index({user_id: 1})
  belongs_to :word
  index({word_id: 1})
  belongs_to :proposal
  index({proposal_id: 1})
  index({type: 1})

  index({created_at: -1})

  field :comment, type: String


  def calculate_percentage_edited
    # total = Word.count
    # Word.proposals.count > 1
    #   return true
    # end
    # (number/total)*100
  end

  def create_comment_activity!
    # Activity.create(user: self.user, proposal: self.proposal, word: self.word, comment: self.comment)
  end

end
