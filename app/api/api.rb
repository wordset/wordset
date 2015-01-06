module Wordset
  class API < Grape::API
    mount Wordset::API::V1 => '/v1'
  end
end
