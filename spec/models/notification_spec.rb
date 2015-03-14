require 'rails_helper'

RSpec.describe Notification, type: :model do

  it "can create a notification when an activity happens" do
    activity = create(:proposal_closed_activity)
    user = create(:user)
    before_count = Notification.count
    activity.notify!(user)
    after_count = Notification.count
    expect(after_count).to eq(before_count + 1)
  end

  it "should send a notification when your proposal is closed" do
    activity = create(:proposal_closed_activity)
    notification = Notification.last
    expect(notification).to_not eq(nil)
    expect(notification.user).to eq(activity.proposal.user)
    expect(notification.activity).to eq(activity)
  end

end
