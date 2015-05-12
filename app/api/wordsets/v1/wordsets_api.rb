module Wordsets
  module V1
    class WordsetsApi < Grape::API
      include Wordsets::V1::Defaults
      resource :wordsets do
        get "/" do
          if params[:meaning_id]
            return [Meaning.find(params[:meaning_id]).wordset]
          end
        end
      end
    end
  end
end
