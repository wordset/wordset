require 'rails_helper'

describe ProposeNewWord do
  before do
    @user = create(:user)
  end

  describe "Valid New Proposal" do
    before :each do
      @name = "subbery"
      @p = ProposeNewWord.new(name: @name, user: @user)
      expect(@p).to_not be_valid
      @p.embed_new_word_meanings.build(pos: "adj",
                                      def: "To be secretly submissive",
                                      example: "I thought the boss was a little subbery",
                                      reason: "Fifty Shades of Grey")
    end

    it "should work with one meaning" do
      expect(@p).to be_valid
    end

    it "Should work with pre-existing pos" do
      word = create(:word)
      @p.name = word.name
      expect(@p).to_not be_valid
    end

    it "shouldn't commit if invalid" do
      count = Word.count
      @p.name = ""
      @p.commit_proposal!
      expect(Word.count).to eq(count)
    end

    it "should create the word if approved!" do
      expect(Word.where(name: @name).count).to eq(0)
      expect(Meaning.count).to eq(0)
      @p.approve!
      expect(Word.where(name: @name).count).to eq(1)
      expect(Meaning.count).to eq(1)
    end

    it "should break with one bad meaning" do
      @p.embed_new_word_meanings.build(pos: "BADPOS",
                                      def: "To be secretly AWESOME",
                                      example: "I thought the boss was a little AWESOME")
      expect(@p).to_not be_valid
    end
  end

end
