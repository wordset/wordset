module Wordset
  module V1
    class Activities < Grape::API
      include Wordset::V1::Defaults

      resource :activities do
        get "/", :each_serializer => ActivitySerializer do
          Activity.limit(20).sort({created_at: -1}).to_a
        end

        # params do
        #   requires :activity, type: Hash do
        #     requires :proposal_id
        #     optional :comment, type: String
        #   end
        # end
        # post "/" do
        #   authorize!
        #   p = Proposal.find(params[:activity][:proposal_id])
        #   a = p.activities.build(comment: params[:activity][:comment])
        #   a.user = @user
        #   a.save!
        #   a
        # end

      end
    end
  end
end
