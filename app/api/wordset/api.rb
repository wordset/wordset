
module Wordset
  class API < Grape::API
    mount Wordset::V1::Base
  end
end
