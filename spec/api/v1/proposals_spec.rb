
require 'rails_helper'

describe Wordset::V1 do
  describe Proposal do
    include LoginHelper

    it "should return its index list" do
      get("/api/v1/proposals")
      data = JSON.parse(response.body)
      expect(data.keys.first).to eq("proposals")
    end

    it "should allow you to propose a removal" do
      meaning = create(:meaning)
      user = create(:user)
      post_as(user, "/api/v1/proposals", proposal: {type: "MeaningRemoval",
                                                    meaning_id: meaning.id})
      expect(response).to be_success
      expect_json_types({proposal: :object})

      p = Proposal.last
      expect(p.meaning).to eq(meaning)
      expect(p.user).to eq(user)
    end
  end
end
