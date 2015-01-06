module Wordset
  class API::V1 < Grape::API
    version 'v1', using: :header, vendor: 'wordset'
  end
end
