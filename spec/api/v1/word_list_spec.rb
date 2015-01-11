
require 'rails_helper'

describe Wordset::V1 do
  describe WordList do
    it "should load the starter list" do
      get('/api/v1/word_lists')
      data = JSON.parse(response.body)
      puts data
    end
  end
end
