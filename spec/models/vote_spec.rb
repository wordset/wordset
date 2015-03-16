require 'rails_helper'

describe Vote do

  before(:each) do
    @proposal = create(:open_proposal)
  end

  def vote!(yae, flagged, rank)
    u = create(:user)
    allow(u).to receive(:rank_id) { rank }
    Vote.create(proposal: @proposal, user: u, yae: yae, flagged: flagged)
  end

  def yae!(rank = :user)
    vote!(true, false, rank)
  end

  def nay!(rank = :user)
    vote!(false, false, rank)
  end

  def flag!(rank = :user)
    vote!(false, true, rank)
  end

  it "should be valid" do
    yae!
    @proposal.reload
    expect(@proposal.votes.count).to eq(2)
    expect(@proposal.tally).to eq(2)
  end

  it "should only allow user to vote once" do
    v = yae!
    new_vote = Vote.create(proposal: @proposal, user: v.user, yae: true)
    expect(new_vote).to_not be_valid
  end

  it "should not allow votes when proposal is closed" do
    @proposal.approve!
    expect(yae!).to_not be_valid
    expect(nay!).to_not be_valid
    expect(flag!).to_not be_valid
  end

  it "should have three points if you vote twice w/ the autovote" do
    yae!
    yae!
    expect(@proposal.tally).to eq(3)
  end

  it "should have minus eight points if you vote yae then contributor votes nay" do
    yae!
    nay!(:contributor)
    expect(@proposal.tally).to eq(-8)
  end

  it "should trigger accepted if enough yae votes are there" do
    yae!(:admin)
    yae!(:admin)
    expect(@proposal.accepted?).to eq(true)
  end

  it "should trigger rejected if enough nay votes are there" do
    nay!(:senior_editor)
    nay!(:senior_editor)
    nay!
    expect(@proposal.rejected?).to eq(true)
  end

  it "should allow editing and restart the vote" do
    vote = yae!(:user)
    flag!(:contributor)
    expect(@proposal.tally).to eq(-8)
    expect(@proposal.flagged_value).to eq(-10)
    @proposal.finished_edit!
    expect(Activity.where(proposal_id: @proposal.id).last.class).to eq(EditProposalActivity)
    expect(@proposal.tally).to eq(1)
    expect(@proposal.flagged_value).to eq(-10)
    new_vote = Vote.create(proposal: @proposal, user: vote.user, yae: true)
    expect(new_vote).to be_valid
    expect(@proposal.tally).to eq(2)
    expect(@proposal.flagged_value).to eq(-10)
  end

  it "should cancel a vote that has been withdrawn" do
    yae!(:editor)
    vote = nay!(:admin)
    expect(@proposal.tally).to eq(-39)
    vote.withdraw!
    expect(@proposal.tally).to eq(36)
  end

  describe "flagging" do
    it "should count as a nay also" do
      flag!
      expect(@proposal.tally).to eq(0)
    end
    it "should mark as flagged after enough flag votes" do
      flag!(:senior_editor)
      expect(@proposal.tally).to eq(-49)
      expect(@proposal.flagged?).to eq(true)
    end

    it "should mark flagged, even if the score is positive" do
      yae!(:editor)
      yae!(:contributor)
      yae!(:contributor)
      flag!(:senior_editor)
      expect(@proposal.tally).to eq(6)
      expect(@proposal.flagged_value).to eq(-50)
      expect(@proposal.flagged?).to eq(true)
    end
  end


end
