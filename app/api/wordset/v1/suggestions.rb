module Wordset
  module V1
    class Suggestions < Grape::API
      include Wordset::V1::Defaults

      resource :suggestions do
        params do
          optional :limit, default: 100
          optional :offset, default: 0
        end
        get '/', each_serializer: SuggestionSerializer do
          Suggestion.limit(params[:limit])
        end

        params do
          requires :suggestion, type: Hash do
            requires :delta, type: Hash
            requires :action, type: String
            requires :target_id
            requires :target_type
          end
        end
        post '/' do
          authorize!
          d = params[:suggestion]
          s = Suggestion.new
          s.delta = d[:delta]
          s.action = d[:action]
          s.user = current_user
          s.target_id = d[:target_id]
          s.target_type = d[:target_type].camelcase
          if !s.target.class.suggestable?
            throw "BAD TARGET"
          end
          if s.target.is_a? Word
            s.word = s.target
          elsif s.target.is_a? Meaning
            s.word = s.target.entry.word
          end
          s.save!
          s
        end
      end
    end
  end
end
