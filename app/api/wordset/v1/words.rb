module Wordset
  module V1
    class Words < Grape::API
      include Wordset::V1::Defaults

      resource :words do
        get '/:id' do
          Word.find(params[:id])
        end
      end
    end
  end
end
