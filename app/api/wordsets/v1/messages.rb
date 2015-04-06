module Wordsets
  module V1
    class Messages < Grape::API
      include Wordset::V1::Defaults

      resource :messages do
        params do
          optional :limit, type: Integer, default: 30
        end
        get '/', each_serializer: MessageSerializer do
          messages = Message.includes(:user).limit(params[:limit]).order({created_at: -1}).to_a
          render messages,
                 meta: { online: User.online_usernames}
        end

        params do
          requires :message, type: Hash do
            requires :text, type: String
            optional :path, type: String
          end
        end
        post '/' do
          authorize!
          message = Message.parse(@user, params[:message][:text], path: params[:message][:path])
          message.save!
          serializer = MessageSerializer.new(message, meta: { online: User.online_usernames})
          Pusher['messages'].trigger('push', serializer.to_json)
          render serializer
        end


      end
    end
  end
end
