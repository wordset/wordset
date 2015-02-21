module Wordset
  module V1
    class Activities < Grape::API
      include Wordset::V1::Defaults

      resource :activities do
        get "/", :each_serializer => ActivitySerializer do
          Activity.limit(20).sort({created_at: -1}).to_a
        end

        params do
          requires :activity, type: Hash do
            requires :proposal_id
            optional :comment, type: String
          end
        end
        post "/", :serializer => ActivitySerializer do
          authorize!
          p = Proposal.find(params[:activity][:proposal_id])

          if !p.open?
            throw "This proposal is closed."
          end
          a = ProposalCommentActivity.new(comment: params[:activity][:comment],
                                         user: current_user,
                                         proposal: p,
                                         word: p.word)
          a.save!
          p.pushUpdate!
          a
        end

      end
    end
  end
end
