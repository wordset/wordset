module Wordset
  module V1
    class Words < Grape::API
      include Wordset::V1::Defaults

      resource :words do

        params do
          optional :meaning_id, type: String
        end
        get '/' do
          if params[:meaning_id]
            [Meaning.find(params[:meaning_id]).word]
          else
            Word.limit(1).offset(rand(Word.count))
          end
        end

        get '/:name' do
          Word.lookup(params[:name])
        end
      end
    end
  end
end
