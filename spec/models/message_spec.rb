require 'rails_helper'

describe Message do
  before(:each) do
    @user = create(:user)
  end

  it "should send normal messages" do
    text = "hello my darling!"
    message = Message.parse(@user, text)
    expect(message).to be_valid
    message.save
    message.reload
    expect(message.class).to eq(MessageSay)
    expect(message.text).to eq(text)
  end
end
