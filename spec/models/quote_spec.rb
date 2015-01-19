

describe Quote do
  describe "Wordnet Imports" do
    it "work without url" do
      expect(build(:wordnet_quote)).to be_valid
    end

    it "need text" do
      expect(build(:wordnet_quote, text: "")).to_not be_valid
    end
  end

  describe "User quotes" do
    it "should fail without url" do
      expect(build(:quote, url: nil)).to_not be_valid
    end
  end
end
