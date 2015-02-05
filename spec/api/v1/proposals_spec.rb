
require 'rails_helper'

describe Wordset::V1 do
  describe Proposal do
    it "should return its index list" do
      get("/api/v1/proposals")
      data = JSON.parse(response.body)
      expect(data.keys.first).to eq("proposals")
    end
  end
end
