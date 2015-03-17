module Wordset
  module V1
    class Posts < Grape::API
      include Wordset::V1::Defaults

      resource :posts do
        get ':slug' do
          Post.where(slug: params[:slug]).first
        end
      end
    end
  end
end
