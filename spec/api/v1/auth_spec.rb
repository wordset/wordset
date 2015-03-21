
require 'rails_helper'

describe Wordset::V1::Auth do
  include LoginHelper

  it "should allow a user to login" do
    user = create(:user)

    post("/api/v1/login", {username: user.username, password: user.password})
    expect(response).to be_successful
    expect_json(username: user.username, auth_key: user.auth_key)
  end

  it "should authorize with the proper Authorization bearer info" do
    get_as(create(:user), "/api/v1/authorized")
    expect(response.body).to eq("true")
  end
end
