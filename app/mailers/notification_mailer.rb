class NotificationMailer < ApplicationMailer
  #default from: 'notifications@wordset.org'

  def run_all(notifications)
    notifications.each do |n|
      send_single(n).deliver
    end
  end

  def single(notification)
    @notification = notification
    @user = @notification.user
    @activity = notification.activity
    case @activity.class
    when ProposalClosedActivity
      @proposal = @activity.proposal
      @word_name = @proposal.word_name
      if @activity.final_state == "accepted"
        mail(to: @user.email,
             subject: "Your Proposal for '#{@word_name}' Was Accepted!",
             template_name: "proposal_approved")
      elsif @activity.final_state == "rejected"
        mail(to: @user.email,
             subject: ":( Your Proposal for '#{@word_name}' Was Rejected.",
             template_name: "proposal_rejected")
      end
    when ProposalCommentActivity
      @proposal = @activity.proposal
      @word_name = @proposal.word_name
      mail(to: @user.email,
           subject: "#{@activity.user.username} commented on your #{@word_name} proposal",
           template_name: "comment")
    when UserPromotionActivity
      mail(to: @user.email,
           subject: "You just made #{@activity.new_level}!",
           template_name: "promotion")
    end

  end
end
