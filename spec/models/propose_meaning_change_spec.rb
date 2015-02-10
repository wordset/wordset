require 'rails_helper'

describe ProposeMeaningChange do

  before do
    @user = create(:user)
    @meaning = create(:meaning)
  end

  describe "Valid New Meaning Proposal" do
    before :each do
      @def = "To be secretly submissive"
      @p = ProposeMeaningChange.new(user: @user,
                                    meaning: @meaning,
                                    def: @def,
                                    example: "I thought the boss was a little subbery")
    end

    it "should be valid" do
      expect(@p).to be_valid
    end

    it "should edit the meaning" do
      @p.save
      original = @meaning.def
      expect(Meaning.where(def: original).count).to eq(1)
      @p.approve!
      expect(Meaning.where(def: original).count).to eq(0)
      expect(Meaning.where(def: @def).count).to eq(1)
      meaning = Meaning.where(def: @def).first
      expect(meaning.accepted_proposal.id).to eq(@p.id)
      expect(meaning.open_proposal).to eq(nil)
    end

    it "shouldn't commit if invalid" do
      count = Meaning.count
      @p.def = ""
      @p.approve!
      expect(Meaning.count).to eq(count)
    end

  end

end
