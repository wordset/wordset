
require 'rails_helper'

describe Wordsets::V1 do
  describe Seq do
    it "Should load a basic seq by key" do
      wordset = create(:wordset)
      seq = wordset.seqs.first
      get("/api/v1/seqs/#{seq.key}")
      expect_json_types({seq: :object, wordsets: :array, meanings: :array})
    end
  end
end
