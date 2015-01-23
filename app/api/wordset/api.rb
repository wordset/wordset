
module Wordset
  class API < Grape::API
    use Appsignal::Grape::Middleware
    mount Wordset::V1::Base
  end
end
