module Wordsets
  module V1
    class Langs < Grape::API
      include Wordsets::V1::Defaults

      resource :langs do
        get '/' do
          Lang.all
        end
      end
    end
  end
end
