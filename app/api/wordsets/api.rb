
module Wordsets
  class API < Grape::API
    mount Wordsets::V1::Base
  end
end
