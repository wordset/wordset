require 'rails_helper'

describe ProposeMeaningRemoval do
  before do
    @user = create(:user)
    @lang = create(:lang)
  end

  before :each do
    @wordset = create(:wordset)
    @meaning = @wordset.entries.first.meanings.first
    @entry = @meaning.entry
    @p = ProposeMeaningRemoval.create(user: @user,
                                      lang: @lang,
                                      wordset: @wordset,
                                      meaning: @meaning,
                                      reason: "This violates some rule or something")
  end

  it "should remove meanings and words if approved" do
    expect(Meaning.count).to eq(1)
    expect(Entry.count).to eq(1)
    expect(Wordset.count).to eq(1)
    expect(@meaning.removed_at).to eq(nil)
    @p.approve!
    @meaning.reload
    expect(@meaning.removed_at).to_not eq(nil)
    expect(Meaning.count).to eq(0)
    expect(Entry.count).to eq(0)
    expect(Wordset.count).to eq(0)
    expect(Meaning.unscoped.find(@meaning.id)).to_not eq(nil)
  end

  it "shouldn't remove entry if there is another meaning" do
    @entry.meanings.create(def: "TESTERIZEINGATION", example: "I have no idea what I'm doing")
    expect(Meaning.count).to eq(2)
    expect(Entry.count).to eq(1)
    expect(Wordset.count).to eq(1)
    @p.approve!
    expect(Meaning.count).to eq(1)
    expect(Entry.count).to eq(1)
    expect(Wordset.count).to eq(1)
  end


  it "should create a new word if the meaning has been deleted" do
    @p.approve!
    @new_p = ProposeNewWordset.new(name: @wordset.name, user: @user, lang: @lang)
    @new_p.embed_new_word_meanings.build(pos: "adj",
                                         def: "To be secretly submissive",
                                         example: "I thought the boss was a little subbery",
                                         reason: "Fifty Shades of Grey")
    expect(@new_p).to be_valid
  end

end
