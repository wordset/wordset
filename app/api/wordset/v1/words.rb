module Wordset
  module V1
    class Words < Grape::API
      include Wordset::V1::Defaults

      resource :words do

        get '/' do
          Word.limit(1).offset(rand(Word.count))
        end

        get '/:name' do
          Word.lookup(params[:name])
        end

      end
    end
  end
end
