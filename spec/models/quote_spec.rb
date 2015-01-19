

describe Quote do
  describe "Wordnet Imports" do
    it "work without url" do
      expect(build(:quote, url: "")).to be_valid
    end

    it "need text" do
      expect(build(:quote, text: "")).to_not be_valid
    end
  end
end
