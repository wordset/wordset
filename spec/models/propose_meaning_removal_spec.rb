require 'rails_helper'

describe ProposeMeaningRemoval do
  before do
    @user = create(:user)
  end

  before :each do
    @word = create(:word)
    @meaning = @word.entries.first.meanings.first
    @entry = @meaning.entry
    @p = ProposeMeaningRemoval.create(user: @user,
                                       word: @word,
                                       meaning: @meaning,
                                       reason: "This violates some rule or something")
  end

  it "should remove meanings and words if approved" do
    expect(Meaning.count).to eq(1)
    expect(Entry.count).to eq(1)
    expect(Word.count).to eq(1)
    expect(@meaning.removed_at).to eq(nil)
    @p.approve!
    @meaning.reload
    expect(@meaning.removed_at).to_not eq(nil)
    expect(Meaning.count).to eq(0)
    expect(Entry.count).to eq(0)
    expect(Word.count).to eq(0)
    expect(Meaning.unscoped.find(@meaning.id)).to_not eq(nil)
  end

  it "shouldn't remove entry if there is another meaning" do
    @entry.meanings.create(def: "TESTERIZEINGATION", example: "I have no idea what I'm doing")
    expect(Meaning.count).to eq(2)
    expect(Entry.count).to eq(1)
    expect(Word.count).to eq(1)
    @p.approve!
    expect(Meaning.count).to eq(1)
    expect(Entry.count).to eq(1)
    expect(Word.count).to eq(1)
  end
end
