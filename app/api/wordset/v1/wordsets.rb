module Wordset
  module V1
    class Wordsets < Grape::API
      include Wordset::V1::Defaults

      resource :wordsets do

        params do
          optional :meaning_id, type: String
        end
        get '/' do
          if params[:meaning_id]
            [Meaning.find(params[:meaning_id]).word]
          else
            Wordset.limit(1).offset(rand(Wordsetcount))
          end
        end

        get '/:name' do
          Wordset.lookup(params[:name])
        end
      end
    end
  end
end
