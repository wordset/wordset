require 'rails_helper'

RSpec.describe User, type: :model do
  include VotingSpecHelper

  before(:each) do
    @proposal = create(:open_proposal)
    @user = create(:user)
  end

  describe "trust level" do
    it "should start at contributor" do
      expect(@user.trust_level).to eq("fresh_face")
    end
  end

  describe "trust points" do
    it "should be above zero for a new user" do
      expect(@user.trust_points).to eq(25)
    end

    it "should compare levels" do
      expect(@user.compare_levels(:fresh_face, :editor)).to be < 0
    end

    it "should neg after a proposal closes" do
      starting_trust = @user.trust_points
      vote_as_user!(@user, true, true) #yae
      @proposal.reject!
      expect(@proposal.rejected?).to eq(true)
      expect(@user.trust_points).to be < starting_trust
    end

    it "should get a promotion for being so right!" do
      notification_count = @user.notifications.count
      25.times do
        @proposal = create(:open_proposal)
        starting_trust = @user.trust_points
        vote_as_user!(@user, true, true) #yae
        @proposal.approve!
        expect(@proposal.accepted?).to eq(true)
        expect(@user.trust_points).to be > starting_trust
      end
      expect(@user.notifications.count).to eq(notification_count + 1)
      expect(@user.trust_level_name).to eq("Junior Contributor")
      activity_classes = @user.activities.map &:class
      expect(activity_classes).to include(UserPromotionActivity)
    end
  end

end
