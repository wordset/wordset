require 'rails_helper'

describe Link do
  before(:each) do
    @domain = create(:domain)
  end

  it "should allow internal links" do
    l = Link.parse("/word/hi")
    expect(l).to be_valid
    expect(l.path).to eq("/word/hi")
  end

  it "should reject non-whitelisted domains" do
    l = Link.parse("http://myspamsite.com/hihihih")
    expect(l).to_not be_valid

    l = Link.parse("http://www.myspamsite.com/hihihih")
    expect(l).to_not be_valid

    l = Link.parse("//www.myspamsite.com")
    expect(l).to_not be_valid
  end

  it "should work with external whitelisted domains" do
    l = Link.parse("http://en.wikipedia.org/path?key=true")
    expect(l).to be_valid
    expect(l.path).to eq("/path?key=true")
  end
end
