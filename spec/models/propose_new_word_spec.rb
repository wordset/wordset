require 'rails_helper'

describe ProposeNewWordset do
  before do
    @user = create(:user)
    @lang = create(:lang)
  end

  describe "Valid New Proposal" do
    before :each do
      @name = "subbery"
      @p = ProposeNewWordset.new(name: @name, user: @user, lang: @lang)
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
      word = create(:wordset)
      @p.name = word.name
      expect(@p).to_not be_valid
    end

    it "shouldn't commit if invalid" do
      @p.save!
      count = Wordset.count
      @p.name = ""
      @p.commit_proposal!
      expect(Wordset.count).to eq(count)
    end

    it "should create the word if approved!" do
      @p.save!
      expect(Seq.where(text: @name).count).to eq(0)
      expect(Meaning.count).to eq(0)
      @p.approve!
      expect(Seq.where(text: @name).count).to eq(1)
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
