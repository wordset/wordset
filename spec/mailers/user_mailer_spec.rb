require "rails_helper"

RSpec.describe UserMailer, :type => :mailer do
  before :each do
    @user = create(:user)
    @official = "contact@wordset.org"
  end

  describe "signed_up" do
    let(:mail) { UserMailer.signed_up(@user) }

    it "renders the headers" do
      expect(mail.to).to eq([@user.email])
      expect(mail.from).to eq([@official])
    end

    it "renders the body" do
      expect(mail.body.encoded).to match("Hampton")
    end
  end

  describe "approved" do
    let(:mail) { UserMailer.approved(@user) }

    it "renders the headers" do
      expect(mail.subject).to eq("Approved")
      expect(mail.to).to eq([@user.email])
      expect(mail.from).to eq([@official])
    end

    it "renders the body" do
      expect(mail.body.encoded).to match("Hi")
    end
  end

  describe "rejected" do
    let(:mail) { UserMailer.rejected(@user) }

    it "renders the headers" do
      expect(mail.subject).to eq("Rejected")
      expect(mail.to).to eq([@user.email])
      expect(mail.from).to eq([@official])
    end

    it "renders the body" do
      expect(mail.body.encoded).to match("Hi")
    end
  end

end
