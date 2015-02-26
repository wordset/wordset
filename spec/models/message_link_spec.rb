require 'rails_helper'

describe MessageLink do
  before(:each) do
    create(:domain)
    @user = create(:user)
  end

  def valid_message(msg, options = {})
    message = Message.parse(@user, msg, options)
    expect(message.class).to eq(MessageLink)
    expect(message.save).to eq(true)
    message.reload

    message
  end

  it "should allow internal links" do
    valid_message "/link /word/hi"
    valid_message "/link", path: "/word/sushi"
  end

  it "should use the arg path over options path" do
    msg = valid_message("/link /word/valid", path: "/word/fail")
    expect(msg.link.path).to eq("/word/valid")
    expect(msg.link.internal_link).to eq(true)
  end

  it "should allow whitelisted domains" do
    url = "https://en.wikipedia.org/wiki/sushi"
    msg = valid_message("/link #{url}")
    expect(msg.link.domain.host).to eq("en.wikipedia.org")
    expect(msg.link.internal_link).to eq(false)
    expect(msg.link.url).to eq(url)
  end
end
