module Wordsets
  module V1
    class Votes < Grape::API
      include Wordsets::V1::Defaults

      resource :votes do
        get "/" do
          Vote.all
        end

        params do
          requires :vote, type: Hash do
            requires :proposal_id
            requires :type, type: String
          end
        end
        post "/" do
          authorize!
          p = Proposal.find(params[:vote][:proposal_id])
          yea = false
          flagged = false
          skip = false
          case params[:vote][:type]
          when "yea"
            yea = true
          when "flag"
            flagged = true
          when "skip"
            skip = true
          end
          v = p.votes.build(yae: yea,
                            flagged: flagged,
                            skip: skip)
          v.user = @user
          v.save!
          p.pushUpdate!
          v
        end

        post '/:id/withdraw', serializer: ProposalSerializer do
          authorize!
          v = Vote.where(user: current_user, id: params[:id]).first
          if v.proposal.open? && !v.usurped?
            v.withdraw!
          end
          v.proposal
        end


      end

    end
  end
end
