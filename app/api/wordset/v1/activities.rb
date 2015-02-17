module Wordset
  module V1
    class Activities < Grape::API
      include Wordset::V1::Defaults

      resource :activities do
        get "/", :each_serializer => ActivitySerializer do
          Activity.limit(20).all
        end
      end
    end
  end
end
