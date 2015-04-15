
require 'rails_helper'

describe Wordsets::V1 do
  describe Proposal do
    include LoginHelper

    it "should return its index list" do
      get("/api/v1/proposals")
      expect_json_types(proposals: :array)
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

    describe "Inline word validator" do
      def check_status(seq)
        get("/api/v1/proposals/new-word-status/#{seq}")
      end

      it "should say 'ok' if the word doesn't exist" do
        check_status("sushieee")
        expect_json(can: true)
      end

      it "should tell you that there is an open proposal" do
        new_word_proposal = create(:propose_new_wordset)
        check_status(new_word_proposal.name)
        expect_json(proposal_id: new_word_proposal.id.to_s, can: false)
      end

      it "should tell you if a word exists" do
        word = create(:wordset)
        check_status(word.seqs.first.text)
        expect_json(can: false, seq_id: word.name)
      end
    end
  end
end
