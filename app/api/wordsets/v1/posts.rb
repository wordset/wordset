module Wordsets
  module V1
    class Posts < Grape::API
      include Wordsets::V1::Defaults

      resource :posts do

        get "/", :each_serializer => PostSerializer do
          Post.where(state: 'published').sort({published_at: -1}).to_a
        end

        get ':slug' do
          post = Post.where(slug: params[:slug], state: 'published').first
          # Treat it like an ID if it doesn't exist or isn't published
          post ||= Post.find(params[:slug])
          post
        end
      end
    end
  end
end
