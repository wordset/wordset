module Wordset
  module V1
    class Messages < Grape::API
      include Wordset::V1::Defaults

      resource :messages do
        params do
          optional :limit, type: Integer, default: 100
        end
        get '/' do
          Message.includes(:user).limit(params[:limit]).order({created_at: -1}).to_a
        end

        params do
          requires :message, type: Hash do
            requires :text, type: String
            optional :path, type: String
          end
        end
        post '/' do
          authorize!
          message = current_user.messages.create!(text: params[:message][:text])
          serializer = MessageSerializer.new(message)
          Pusher['messages'].trigger('push', serializer.to_json)
          render serializer
        end
      end
    end
  end
end
