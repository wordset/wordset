require 'rails_helper'

describe ProposeNewWordset do
  before do
    @user = create(:user)
    @lang = create(:lang)
    @label = create(:label)
  end

  describe "Valid New Proposal" do
    before :each do
      @name = "subbery"
      @p = ProposeNewWordset.new(name: @name, user: @user, lang: @lang)
      @speech_part = SpeechPart.first || create(:speech_part)
      expect(@p).to_not be_valid
      @p.embed_new_word_meanings.build(pos: @speech_part.code,
                                      def: "To be secretly submissive",
                                      example: "I thought the boss was a little subbery",
                                      reason: "Fifty Shades of Grey")
    end

    it "should work with one meaning" do
      expect(@p).to be_valid
    end

    it "should work with pre-existing pos" do
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

    it "should break without having a reason" do
      @p.embed_new_word_meanings.build(pos: @speech_part.code,
                                      def: "To be secretly AWESOME",
                                      example: "I thought the boss was a little AWESOME")
      expect(@p).to_not be_valid
    end

    it "should apply labels to new words" do
      e = @p.embed_new_word_meanings.build(pos: @speech_part.code,
                                       def: "To black out from excitement",
                                       example: "I totally ajiousrojsijoijed this morning",
                                       reason: "my experience dsafsfs afads ",
                                       label_ids: [@label.id])
      @p.save!
      @p.approve!
      expect(Meaning.count).to eq(2)
      expect(Meaning.last.labels.first.id).to eq(@label.id)
    end
  end

end
