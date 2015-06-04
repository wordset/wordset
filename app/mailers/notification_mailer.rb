class NotificationMailer < ApplicationMailer
  #default from: 'notifications@wordset.org'


  def digest(user, notifications)
    @notifications = (notifications.to_a.sort_by do |notification|
      notification.activity ? notification.activity.digest_importance : 0
    end)
    @user = user
    @proposal = Proposal.last
    @word_name = @proposal.word_name
    mail(to: user.email,
         subject: "#{notifications.count} new notifications on Wordset")
  end

  def promoted(activity)
    @activity = activity
    @user = activity.user
    mail(to: @user.email,
         subject: "You just made #{@activity.new_level}!",
         template_name: "promoted")
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
    when UserBadgeActivity
      @badge = @activity.badge
      mail(to: @user.email,
           subject: "You just got the #{@badge.full_name} Badge!!!!",
           template_name: "badge")
    end

  end
end
