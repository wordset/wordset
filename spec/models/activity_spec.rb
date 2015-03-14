require 'rails_helper'

describe Activity do
  before(:each) do
    @proposal = create(:open_proposal)
  end

  it "should create vote activity" do
    Vote.create(proposal: @proposal, user: create(:user), yae: true)
    a = Activity.where(proposal: @proposal).last
    expect(a.class).to eq(VoteActivity)
  end

  it "should create initial activity when created" do
    a = Activity.where(proposal: @proposal).first
    expect(a.class).to eq(NewProposalActivity)
  end

  it "should create final activity with correct state" do
    @proposal.approve!
    a = @proposal.activities.last
    expect(a.final_state).to eq("accepted")
  end

  it "should not create an activity when flagged" do
    @proposal.flag!
    a = @proposal.activities.last
    expect(a.class).to_not eq(ProposalClosedActivity)
  end

end
