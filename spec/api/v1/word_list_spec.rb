
require 'rails_helper'

describe Wordset::V1 do
  describe WordList do
    it "should load the starter list" do
      create_list :word, 100
      create :word, name: "aa"
      get('/api/v1/word_lists')
      data = JSON.parse(response.body)
      expect(data.keys.first).to eq("word_lists")
      word_lists = data["word_lists"]
      expect(word_lists.size).to be >= 5
      word_lists.each do |list|
        expect(list["id"]).to(match(/[a-z]{1,2}/))
        expect(list["results"]).to be_a(Array)

        # If this is the "a" search, we should definitely have something
        # because we added it at the top!
        if list["id"] == "a"
          list["results"].each do |word|
            expect(word["name"]).to be_an_instance_of(String)
            expect(word["word_id"]).to be_an_instance_of(String)
          end
        end
      end
    end
  end
end
