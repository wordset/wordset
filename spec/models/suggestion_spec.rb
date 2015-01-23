require 'rails_helper'

describe Suggestion do
  describe "Quote Suggestion" do
    before(:each) do
      @original_quote_text = "To be or not to be"
      @quote = create(:quote, text: @original_quote_text)
      @user = create(:user)
    end

    it "should apply non-nested suggestion" do
      new_text = "Hello, mom! I'm here! Totally here."
      suggestion = @quote.suggest_change(@user, text: new_text)
      expect(@quote.text).to eq(@original_quote_text)
      @quote.apply_suggestion(suggestion["delta"])
      expect(@quote.text).to eq(new_text)
    end

    describe "new change suggestions" do
      it "should allow valid suggestions" do
        suggestion = @quote.suggest_change(@user, text: "Hello, mom! I'm here! Totally here.")
        expect(suggestion).to be_valid
      end

      it "should pass through errors from target" do
        suggestion = @quote.suggest_change(@user, text: "small")
        expect(suggestion).to_not be_valid
        expect(suggestion.errors[:text].first).to start_with("is too short")
      end

      it "should block non-whitelisted suggestions" do
        suggestion = @quote.suggest_change(@user, security_hole: "GOTCHA!!!")
        expect(suggestion).to_not be_valid
      end

      # This could be a SCARY side effect from the way validations are built
      it "shouldn't effect target" do
        suggestion = @quote.suggest_change(@user, text: "Hello, mom! I'm here! Totally here.")
        # Save the suggestion, includes validation
        expect(suggestion.save).to eq(true)
        # Reload the quote and make sure it's not saved
        @quote.reload
        expect(@quote.text).to eq(@original_quote_text)
      end
    end

    describe "create action" do
      it "should build with proper attributes" do
        meaning = create(:meaning)
        suggestion = Quote.suggest(@user, {text: @original_quote_text, source: "Hampton Catlin", url: "http://www.google.com"}, meaning)
        expect(suggestion).to be_valid
      end

      it "should error on invalid model" do
        meaning = create(:meaning)
        suggestion = Quote.suggest(@user, {}, meaning)
        expect(suggestion).to_not be_valid
      end

      it "should fail on non-whitelisted attributes" do
        meaning = create(:meaning)
        suggestion = Quote.suggest(@user, {bad: true, text: @original_quote_text, source: "Hampton Catlin", url: "http://www.google.com"}, meaning)
        expect(suggestion).to_not be_valid
      end
    end
  end

  describe "Word Suggestion" do
    before(:each) do
      @user = create(:user)
      @valid_delta = {name: "Hampton", entries: [{pos: "noun", meanings: [{def: "An awesome guy", quotes: [{text: "Hampton is such a great guy", source: "Hampton", url: "http://www.hamptoncatlin.com"}]}]}]}
    end

    it "Should have valid children" do
      s = Word.suggest(@user, {name: "hellothere!"})
      expect(s).to_not be_valid
    end

    it "Can be valid, saved, and committed!" do
      expect(@user.suggestions.count).to eq(0)
      expect(Word.count).to eq(0)
      expect(Quote.count).to eq(0)
      s = Word.suggest(@user, @valid_delta)
      expect(s).to be_valid
      expect(s.save).to eq(true)
      s.approve
      s.save
      expect(@user.suggestions.count).to eq(1)
      expect(Word.count).to eq(1)
      expect(Quote.count).to eq(1)
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

  describe "Meaning suggestion" do
    before :each do
      @user = create(:user)
    end

    it "can change meaning without editing pre-existing quote" do
      meaning = create(:meaning)
      s = meaning.suggest_change(@user, {def: "sushi is delicious, you know"})
      expect(s).to be_valid
    end

    describe "from imported wordnet meaning" do
      it "doesnt need a quote" do
        meaning = create(:wordnet_meaning)
        meaning.quotes = []
        expect(meaning).to be_valid
        s = meaning.suggest_change(@user, {def: "sushi is delicious, you know"})
        expect(s).to be_valid
      end
    end
  end
end
