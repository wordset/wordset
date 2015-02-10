module Wordset
  module V1
    class Votes < Grape::API
      include Wordset::V1::Defaults

      resource :votes do
        get "/" do
          Vote.all
        end

        params do
          requires :vote, type: Hash do
            requires :proposal_id
            requires :yae, type: Boolean
            optional :flagged, type: Boolean
            optional :comment, type: String
          end
        end
        post "/" do
          authorize!
          p = Proposal.find(params[:vote][:proposal_id])
          v = p.votes.build(yae: params[:vote][:yae], flagged: params[:vote][:flagged], comment: params[:vote][:comment])
          v.user = @user
          v.save!
          v
        end
      end

    end
  end
end
