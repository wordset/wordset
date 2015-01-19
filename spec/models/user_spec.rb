require 'rails_helper'

describe User do
  it "should be valid" do
    expect(build(:user)).to be_valid
  end
end
