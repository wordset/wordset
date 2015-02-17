module Wordset
  module V1
    class Activities < Grape::API
      include Wordset::V1::Defaults

      resource :activities do
        get "/", :each_serializer => ActivitySerializer do
          Activity.limit(20).sort({created_at: -1}).to_a
        end
      end
    end
  end
end
