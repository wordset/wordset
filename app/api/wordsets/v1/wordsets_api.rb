module Wordsets
  module V1
    class WordsetsAPI < Grape::API
      include Wordsets::V1::Defaults

      resource :wordsets do

        params do
          optional :meaning_id, type: String
        end
        get '/' do
          if params[:meaning_id]
            [Meaning.find(params[:meaning_id]).word]
          else
            Wordset.limit(1).offset(rand(Wordset.count))
          end
        end
      end
    end
  end
end
