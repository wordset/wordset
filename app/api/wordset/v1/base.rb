module Wordset
  module V1
    class Base < Grape::API
      include Wordset::V1::Defaults

      mount Wordset::V1::Words
      mount Wordset::V1::WordLists
    end
  end
end
