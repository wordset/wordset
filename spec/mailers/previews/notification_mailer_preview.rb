# Preview all emails at http://localhost:3000/rails/mailers/notification_mailer
class NotificationMailerPreview < ActionMailer::Preview
  def single
    NotificationMailer.single(Notification.last)
  end

  def digest
    @user = User.first
    @activities = [
      ProposalClosedActivity.where(final_state: "accepted").last,
      ProposalClosedActivity.where(final_state: "rejected").last,
      ProposalCommentActivity.last,
      EditProposalActivity.last,
      NewProposalActivity.last,
      UserPromotionActivity.last,
      WithdrawVoteActivity.last
    ]
    @notifications = (@activities.map &:notifications).flatten.uniq.shuffle
    NotificationMailer.digest(@user, @notifications)
  end
end
