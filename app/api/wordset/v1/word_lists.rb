module Wordset
  module V1
    class WordLists < Grape::API
      include Wordset::V1::Defaults
      resource :word_lists do
        desc 'List of common starter lists'
        get '/' do
          WordList.starter_pack
        end

        desc 'Return a WordList from search term'
        params do
          requires :term
        end
        get "/:term" do
          WordList.search(params[:term])
        end
      end
    end
  end
end
