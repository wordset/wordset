require 'rails_helper'

describe Suggestion do
  describe "Quote Suggestion" do
    before(:each) do
      @original_quote_text = "To be or not to be"
      @quote = create(:quote, text: @original_quote_text)
      @user = create(:user)
    end

    it "should apply_suggestion" do
      new_text = "Hello, mom! I'm here! Totally here."
      suggestion = @quote.suggest_change(@user, text: new_text)
      expect(@quote.text).to eq(@original_quote_text)
      @quote.apply_suggestion(suggestion)
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
      it "should work with proper attributes" do
        suggestion = Quote.suggest(@user, {text: @original_quote_text, source: "Hampton Catlin", url: "http://www.google.com"})
      end
    end
  end
end
