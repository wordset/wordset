module Wordset
  module V1
    class Notifications < Grape::API
      include Wordset::V1::Defaults


      resource :notifications do
        desc "A client sends a read-reciept using this ACK method"
        post '/:id/ack' do
          authorize!
          @user.notifications.where(id: params[:id]).first.ack!
          render text: "ok"
        end

        desc "Email Link"
        params do
          requires :url
        end
        get '/:id/click' do
          Notification.find(params[:id]).clicked_email_link!
          redirect params[:url], permanent: true
        end
      end
    end
  end
end
