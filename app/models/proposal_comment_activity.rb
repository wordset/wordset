class ProposalCommentActivity < Activity

  def self.migrate_comments
    VoteActivity.ne(comment: nil).each do |va|
      ProposalCommentActivity.create(
        comment: va.comment,
        proposal: va.proposal,
        word: va.word,
        user: va.user,
        created_at: va.created_at,
        updated_at: va.updated_at
        )
      va.update_attributes(comment: nil)
    end
  end
end
