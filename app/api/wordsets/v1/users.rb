module Wordsets
  module V1
    class Users < Grape::API
      include Wordset::V1::Defaults

      resource :users do
        desc "Top users"
        params do
          optional :user_id
        end
        get '/' do
          u = User.all.order(:points => -1, :last_seen_at => -1)
          if params[:user_id]
            requested_user = User.where(username: params[:user_id]).first
            higher_than_requested_user = User.where(:points.gt => requested_user.points).count
            u = u.limit(3)
            if higher_than_requested_user > 0
              u = u.offset(higher_than_requested_user-1)
            end
          end
          u
        end

        desc "Load user info"
        get '/:username' do
          User.where(username: params[:username]).first
        end

        desc "Register New User"
        params do
          requires :user, type: Hash do
            requires :id, :type => String, :desc => "Username"
            requires :email, :type => String, :desc => "User email"
            requires :password, :type => String, :desc => "User password"
            requires :accept_tos, :type => Boolean
            optional :email_opt_in, :type => Boolean
          end
        end
        post '/', serializer: NewUserSerializer do
          user_params = params[:user]
          email = user_params[:email]
          password = user_params[:password]

          u = User.new(email: email,
                          password: password,
                          password_confirmation: password,
                          username: user_params[:id])
          if user_params[:accept_tos]
            u.accept_tos_at = Time.now
            u.accept_tos_ip = env['REMOTE_ADDR']
          end
          if user_params[:email_opt_in]
            u.email_opt_in_at = Time.now
            u.email_opt_in_ip = env['REMOTE_ADDR']
          end
          u.save!
          UserMailer.signed_up(u).deliver
          u
        end

        params do
          requires :email, type: String
        end
        post '/forgot_password' do
          user = User.where(email: params[:email]).first
          if user
            user.send(:set_reset_password_token)
            user.reset_password_sent_at = Time.now
            user.save
            UserMailer.forgot_password(user).deliver
          end
          true
        end

        params do
          requires :token, type: String
          requires :password, type: String
        end
        post '/reset_password' do
          user = User.where(reset_password_token: params[:token]).first
          if user.reset_password_sent_at < 2.hours.ago
            throw "invalid"
          end
          user.update_attributes(password: params[:password],
                                 password_confirmation: params[:password],
                                 reset_password_token: nil,
                                 reset_password_sent_at: nil)
          {username: user.username}
        end

        get '/:id/unsubscribe' do
          User.find(params[:id]).update_attributes(unsubscribed: true)
          render text: "Sorry to see you go! Email us if you want to be added back in!"
        end
      end
    end
  end
end
