require 'rails_helper'

describe Suggestion do
  describe "Meaning Suggestion" do
    before(:each) do
      @original_meaning_text = "To be or not to be"
      @meaning = create(:meaning, def:  @original_meaning_text)
      @entry = @meaning.entry
      @word = @entry.word
      @user = create(:user)
    end

    it "should apply non-nested suggestion" do
      new_text = "Hello, mom! I'm here! Totally here."
      suggestion = @meaning.suggest_change(@user, def:  new_text)
      expect(@meaning.def).to eq(@original_meaning_text)
      @meaning.apply_suggestion(suggestion["delta"])
      expect(@meaning.def).to eq(new_text)
    end

    describe "new change suggestions" do
      it "should allow valid suggestions" do
        suggestion = @meaning.suggest_change(@user, def: "Hello, mom! I'm here! Totally here.")
        expect(suggestion).to be_valid
      end

      it "should pass through errors from target" do
        suggestion = @meaning.suggest_change(@user, def:  "small")
        expect(suggestion).to_not be_valid
        expect(suggestion.errors[:def].first).to start_with("is too short")
      end

      it "should block non-whitelisted suggestions" do
        suggestion = @meaning.suggest_change(@user, security_hole: "GOTCHA!!!")
        expect(suggestion).to_not be_valid
      end

      # This could be a SCARY side effect from the way validations are built
      it "shouldn't effect target" do
        suggestion = @meaning.suggest_change(@user, def:  "Hello, mom! I'm here! Totally here.")
        # Save the suggestion, includes validation
        expect(suggestion.save).to eq(true)
        # Reload the meaning and make sure it's not saved
        @meaning.reload
        expect(@meaning.def).to eq(@original_meaning_text)
      end
    end

    describe "create action" do
      it "should build with proper attributes" do
        suggestion = Meaning.suggest(@user, {def:  @original_meaning_text, example: "Hampton Catlin"}, @entry)
        expect(suggestion).to be_valid
      end

      it "should error on invalid model" do
        suggestion = Meaning.suggest(@user, {}, @entry)
        expect(suggestion).to_not be_valid
      end

      it "should fail on non-whitelisted attributes" do
        suggestion = Meaning.suggest(@user, {bad: true, def:  @original_meaning_text, example: "Hampton is awesome"}, @entry)
        expect(suggestion).to_not be_valid
      end
    end
  end

  describe "Word Suggestion" do
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
      s = Word.suggest(@user, {name: "hellothere!"})
      expect(s).to_not be_valid
    end

    it "Can be valid, saved, and committed!" do
      expect(@user.suggestions.count).to eq(0)
      expect(Word.count).to eq(0)
      expect(Meaning.count).to eq(0)
      s = Word.suggest(@user, @valid_delta)
      expect(s).to be_valid
      expect(s.save).to eq(true)
      s.approve
      s.save
      expect(@user.suggestions.count).to eq(1)
      expect(Word.count).to eq(1)
      expect(Meaning.count).to eq(1)
      word = Word.where(name: "Hampton").first
      expect(word.name).to eq("Hampton")
      expect(word.entries.first.pos).to eq("noun")
    end

    it "Should reject invalid children" do
      invalid_delta = @valid_delta
      invalid_delta[:entries].first[:meanings].first["invalid"] = "now"
      s = Word.suggest(@user, invalid_delta)
      expect(s).to_not be_valid
    end
  end
end
