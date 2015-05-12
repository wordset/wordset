
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

    describe ProposeNewWordset do
      before do
        @lang = create(:lang)
        @speech_part = SpeechPart.first
        @user = create(:user)
      end

      def post_new_word_proposal(options = {})
        attributes = options.reverse_merge({
          type: "NewWordset",
          lang_id: @lang.code,
          word_name: Faker::Lorem.words(2).join("-"),
          meanings: [
            { pos: @speech_part.code,
              def: "Hello there, governer.",
              example: "This isn't a real word",
              reason: "http://en.wikipedia.org/w/Hackney"
             }
          ]
        })
        post_as(@user, "/api/v1/proposals", {proposal: attributes})
      end

      def create_new_word_proposal(options = {})
        post_new_word_proposal(options)
        expect(response).to be_successful
        expect_json_types(proposal: :object)
        data = JSON.parse(response.body)
        Proposal.find(data["proposal"]["id"])
      end

      it "should get created" do
        create_new_word_proposal
      end

      it "should allow editing with multiple meanings" do
        meanings = [
          { pos: @speech_part.code,
            def: "Hello there, governer.",
            example: "This isn't a real word",
            reason: "http://en.wikipedia.org/w/Hackney"
          },
          { pos: @speech_part.code,
            def: "Second meaning, man!",
            example: "Second meaning, man!",
            reason: "http://en.wikipedia.org/w/Hackney"
           }
        ]
        proposal = create_new_word_proposal(meanings: meanings)
        new_def = "Hello there, governe"
        meanings[0][:def] = new_def
        do_as(:put,
          @user,
          "/api/v1/proposals/#{proposal.id}",
          proposal: {
            meanings: meanings
          })
        expect(response).to be_successful
        proposal.reload
        expect(proposal.embed_new_word_meanings.count).to eq(2)
        expect(proposal.embed_new_word_meanings.first.def).to eq(new_def)
      end
    end

    describe ProposeMeaningChange do
      before do
        @lang = create(:lang)
        @user = create(:user)
        @label = create(:label)
      end

      before :each do
        @meaning = create(:meaning)
      end

      it "should be able to propose a meaning change" do
        post_as(@user, "/api/v1/proposals", {
          proposal: {
            type: "MeaningChange",
            def: "Nunsdfs fdnu ofsdn fdsa funsaio",
            example: "YIOiasof sd fjsa fjksadl jsa",
            meaning_id: @meaning.id,
            label_ids: [@label.id]
          }
        })
        p = Proposal.last
        data = JSON.parse(response.body)
        expect_json_types(proposal: :object)
        expect(data["proposal"]["label_ids"]).to eq([@label.id.to_s])

        p.approve!

        get("/api/v1/seqs/#{@lang.code}-#{@meaning.wordset.seqs.first.text}")
        seq_data = JSON.parse(response.body)
        seq_data["meanings"][0]["label_ids"]
      end
    end
  end
end
