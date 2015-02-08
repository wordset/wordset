require 'rails_helper'

describe Vote do

  before(:each) do
    @user = create(:user)
    @proposal = create(:open_proposal)
    @v = Vote.create(proposal: @proposal, user: @user, yae: true)
    expect(@v).to be_valid
  end

  it "should be valid" do
    @proposal.reload
    expect(@proposal.votes.count).to eq(1)
    expect(@proposal.tally).to eq(1)
  end

  it "should only allow user to vote once" do
    new_vote = Vote.create(proposal: @proposal, user: @user, yae: true)
    expect(new_vote).to_not be_valid
  end

  it "should not allow votes when proposal is closed" do
    @proposal.approve!
    new_user = create(:user)
    v = Vote.create(proposal: @proposal, user: new_user, yae: true)
    expect(v).to_not be_valid

  end

end
