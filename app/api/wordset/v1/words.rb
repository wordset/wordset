module Wordset
  module V1
    class Words < Grape::API
      include Wordset::V1::Defaults

      resource :words do

      end
    end
  end
end
