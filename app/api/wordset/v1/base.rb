module Wordset
  module V1
    class Base < Grape::API
      include Wordset::V1::Defaults

      get '/' do
        Word.where(name: "just").first
      end
    end
  end
end
