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
      expect(@user.trust_level_name).to eq("Junior Contributor")
      activity_classes = @user.activities.map &:class
      expect(activity_classes.count(UserPromotionActivity)).to eq(1)

      # now, let's be a little wrong... but within the bounds
      # of how often we can be wrong!
      20.times do
        @proposal = create(:open_proposal)
        starting_trust = @user.trust_points
        vote_as_user!(@user, true, true) #yae
        @proposal.reject!
        expect(@proposal.rejected?).to eq(true)
        expect(@user.trust_level_name).to eq("Junior Contributor")
        expect(@user.trust_points).to be < starting_trust
      end
      @proposal = create(:open_proposal)
      starting_trust = @user.trust_points
      vote_as_user!(@user, true, true) #yae
      @proposal.reject!
      expect(@proposal.rejected?).to eq(true)
      @user = User.find(@user.id)
      @user.save
      expect(@user.trust_level_name).to_not eq("Junior Contributor")
      expect(@user.trust_points).to be < starting_trust
      # get demoted :(
    end
  end

end
