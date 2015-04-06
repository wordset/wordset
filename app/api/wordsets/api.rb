
module Wordsets
  class API < Grape::API
    use Appsignal::Grape::Middleware
    mount Wordsets::V1::Base
  end
end
