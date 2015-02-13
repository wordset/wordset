module Wordset
  module V1
    class Words < Grape::API
      include Wordset::V1::Defaults

      resource :words do
        get '/:name' do
          Word.lookup(params[:name])
        end
      end
    end
  end
end
