
module Wordset
  class API < Grape::API
    mount Wordset::V1::Base => '/v1'
  end
end
