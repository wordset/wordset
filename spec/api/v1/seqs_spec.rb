
require 'rails_helper'

describe Wordsets::V1 do
  describe Seq do
    it "Should load a basic seq by key" do
      wordset = create(:wordset)
      seq = wordset.seqs.first
      get("/api/v1/seqs/#{seq.key}")
      expect_json_types({seq: :object, wordsets: :array, meanings: :array})
    end

    it "should return a full list of all the seqs, including this one" do
      wordset = create(:wordset)
      seq = wordset.seqs.first
      get("/api/v1/seqs/#{seq.lang.code}.list")
      expect_json_types({list: :string})
      assert JSON.parse(response.body)["list"].include?(seq.text)
    end
  end
end
