require 'rails_helper'

describe ProposeNewMeaning do
  before do
    @user = create(:user)
    @word = create(:word)
  end

  describe "Valid New Meaning Proposal" do
    before :each do
      @p = ProposeNewMeaning.new(word: @word,
                                 user: @user,
                                 pos: "adj",
                                 def: "To be secretly submissive",
                                 example: "I thought the boss was a little subbery")
    end

    it "should be valid" do
      expect(@p).to be_valid
    end

    it "should create a new entry" do
      @p.save
      entry_count = Entry.count
      @p.approve!
      expect(Entry.count).to eq(entry_count + 1)
    end

    it "Should work if it's the same entry too" do
      @p.pos = "noun"
      @p.save
      entry_count = Entry.count
      @p.approve!
      expect(Entry.count).to eq(entry_count)
    end

    it "shouldn't commit if invalid" do
      count = Meaning.count
      @p.def = ""
      @p.approve!
      expect(Meaning.count).to eq(count)
    end
  end

end
