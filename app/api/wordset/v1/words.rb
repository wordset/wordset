module Wordset
  module V1
    class Words < Grape::API
      include Wordset::V1::Defaults

      resource :words do
        get '/' do
          "words"
        end

        desc 'Return some words from search term'
        params do
          requires :term
        end
        get "search", each_serializer: WordListSerializer do
          term = params["term"]
          Word.limit(10).where({ :name => /^#{term}.*/i }).to_a
        end
      end
    end
  end
end
