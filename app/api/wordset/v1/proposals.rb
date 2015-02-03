module Wordset
  module V1
    class Proposals < Grape::API
      include Wordset::V1::Defaults

      resource :proposals do
        params do
          optional :limit, default: 25
          optional :offset, default: 0
        end
        get '/', each_serializer: ProposalSerializer do
          Proposal.includes(:user).limit(params[:limit]).sort({created_at: -1}).to_a
        end


        get '/:id', each_serializer: ProposalSerializer do
          Proposal.find(params[:id])
        end

        params do
          requires :proposal, type: Hash do
            requires :delta, type: Hash
            requires :action, type: String
            requires :reason, type: String
            requires :target_id
            requires :target_type
            optional :create_class_name, type: String
          end
        end
        post '/' do
          authorize!
          d = params[:proposal]
          s = Proposal.new
          s.delta = d[:delta]
          s.action = d[:action]
          s.reason = d[:reason]
          s.user = current_user

          s.target_id = d[:target_id]
          s.target_type = d[:target_type].camelcase
          if !s.target.class.editable?
            throw "BAD TARGET"
          end
          if s.create?
            s.create_class_name = d[:create_class_name]
          end
          if s.target.is_a? Word
            s.word = s.target
          elsif s.target.is_a? Meaning
            s.word = s.target.entry.word
          elsif s.target.is_a? Entry
            s.word = s.target.word
          end
          s.save!
          s
        end
      end
    end
  end
end
