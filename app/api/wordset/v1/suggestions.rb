module Wordset
  module V1
    class Suggestions < Grape::API
      include Wordset::V1::Defaults
      resource :suggestions do

        desc "Get a list of suggestions for that particular word"
        params do
          requires :word_id
        end
        get '/', each_serializer: SuggestionSerializer do
          puts params.inspect
          Word.find(params[:word_id]).suggestions
        end

        desc "Create a new suggestion"
        params do
          requires :suggestion, type: Hash do
            requires :word_id
            requires :entries, type: Array do
              requires :pos
              requires :meanings, type: Array do
                requires :def
                optional :quotes, type: Array do
                  requires :text
                  optional :source
                end
              end
            end
          end
        end
        post '/' do
          authorize!
          word = Word.find(params[:suggestion][:word_id])
          Suggestion.create(word: word, entries: params[:suggestion][:entries], user: current_user)
        end
      end
    end
  end
end
