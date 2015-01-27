require 'rails_helper'

describe Proposal do
  describe "Meaning Proposal" do
    before(:each) do
      @original_meaning_text = "To be or not to be"
      @meaning = create(:meaning, def:  @original_meaning_text)
      @entry = @meaning.entry
      @word = @entry.word
      @user = create(:user)
    end

    it "should apply non-nested proposal" do
      new_text = "Hello, mom! I'm here! Totally here."
      proposal = @meaning.propose_change(@user, def:  new_text)
      expect(@meaning.def).to eq(@original_meaning_text)
      @meaning.apply_proposal(proposal["delta"])
      expect(@meaning.def).to eq(new_text)
    end

    describe "new change proposals" do
      it "should allow valid proposals" do
        proposal = @meaning.propose_change(@user, def: "Hello, mom! I'm here! Totally here.")
        expect(proposal).to be_valid
      end

      it "should pass through errors from target" do
        proposal = @meaning.propose_change(@user, def:  "small")
        expect(proposal).to_not be_valid
        expect(proposal.errors[:def].first).to start_with("is too short")
      end

      it "should block non-whitelisted proposals" do
        proposal = @meaning.propose_change(@user, security_hole: "GOTCHA!!!")
        expect(proposal).to_not be_valid
      end

      # This could be a SCARY side effect from the way validations are built
      it "shouldn't effect target" do
        proposal = @meaning.propose_change(@user, def:  "Hello, mom! I'm here! Totally here.")
        # Save the proposal, includes validation
        expect(proposal.save).to eq(true)
        # Reload the meaning and make sure it's not saved
        @meaning.reload
        expect(@meaning.def).to eq(@original_meaning_text)
      end
    end

    describe "create action" do
      it "should build with proper attributes" do
        proposal = Meaning.propose(@user, {def:  @original_meaning_text, example: "Hampton Catlin"}, @entry)
        expect(proposal).to be_valid
      end

      it "should error on invalid model" do
        proposal = Meaning.propose(@user, {}, @entry)
        expect(proposal).to_not be_valid
      end

      it "should fail on non-whitelisted attributes" do
        proposal = Meaning.propose(@user, {bad: true, def:  @original_meaning_text, example: "Hampton is awesome"}, @entry)
        expect(proposal).to_not be_valid
      end
    end
  end

  describe "Word Proposal" do
    before(:each) do
      @user = create(:user)
      @valid_delta = {name: "Hampton",
                      entries: [
                        {pos: "noun",
                         meanings: [
                           {def: "An awesome guy", example: "Hampton is such a great guy"}
                         ]}]}
    end

    it "Should have valid children" do
      s = Word.propose(@user, {name: "hellothere!"})
      expect(s).to_not be_valid
    end

    it "Can be valid, saved, and committed!" do
      expect(@user.proposals.count).to eq(0)
      expect(Word.count).to eq(0)
      expect(Meaning.count).to eq(0)
      s = Word.propose(@user, @valid_delta)
      expect(s).to be_valid
      expect(s.save).to eq(true)
      s.approve
      s.save
      expect(@user.proposals.count).to eq(1)
      expect(Word.count).to eq(1)
      expect(Meaning.count).to eq(1)
      word = Word.where(name: "Hampton").first
      expect(word.name).to eq("Hampton")
      expect(word.entries.first.pos).to eq("noun")
    end

    it "Should reject invalid children" do
      invalid_delta = @valid_delta
      invalid_delta[:entries].first[:meanings].first["invalid"] = "now"
      s = Word.propose(@user, invalid_delta)
      expect(s).to_not be_valid
    end
  end
end
