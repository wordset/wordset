module Wordsets
  module V1
    class Langs < Grape::API
      include Wordsets::V1::Defaults

      resource :langs do
        get '/' do
          Lang.all
        end

        get '/:code' do
          Lang.where(code: params[:code]).first
        end

      end
    end
  end
end
