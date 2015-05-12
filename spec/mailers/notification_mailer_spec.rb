require "rails_helper"

RSpec.describe NotificationMailer, type: :mailer do
  before do
    @official = "contact@wordset.org"
  end

  describe "comment notification" do
    before :each do
      @comment = create(:proposal_comment_activity)
      @preposer = @comment.proposal.user
      @notification = @comment.notifications.first
    end
    let(:mail) { NotificationMailer.single(@notification) }

    it "renders the headers" do
      expect(mail.to).to eq([@preposer.email])
      expect(mail.from).to eq([@official])
    end

    it "renders the body" do
      expect(mail.body.encoded).to match(@comment.user.username)
    end
  end
end
