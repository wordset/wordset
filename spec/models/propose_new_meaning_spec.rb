require 'rails_helper'

describe ProposeNewMeaning do
  before do
    @user = create(:user)
    @wordset = create(:wordset)
    @lang = create(:lang)
    @speech_part = create(:speech_part)
    @label = create(:label)
  end

  describe "Valid New Meaning Proposal" do
    before :each do
      @p = ProposeNewMeaning.new(wordset: @wordset,
                                 user: @user,
                                 lang: @lang,
                                 speech_part: @speech_part,
                                 def: "To be secretly submissive",
                                 example: "I thought the boss was a little subbery")
    end

    it "should be valid" do
      expect(@p).to be_valid
    end

    it "should create a new meaning" do
      @p.save
      meaning_count = @wordset.meanings.count
      @p.approve!
      expect(@wordset.meanings.count).to eq(meaning_count + 1)
    end

    it "shouldn't commit if invalid" do
      count = Meaning.count
      @p.def = ""
      @p.approve!
      expect(Meaning.count).to eq(count)
    end

    it "should apply label to new meaning" do
      @p.labels << @label
      @p.save!
      @p.approve!
      meaning = Meaning.where(accepted_proposal_id: @p.id).first
      expect(meaning.labels.count).to eq(1)
      expect(meaning.labels.first.id).to eq(@label.id)
    end

  end

end
