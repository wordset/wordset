module Wordset
  module V1
    class Users < Grape::API
      include Wordset::V1::Defaults

      resource :users do
        desc "Top users"
        get '/' do
          User.all.desc(:points)
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
            u.email_opt_in_at = Time.now
            u.email_opt_in_ip = env['REMOTE_ADDR']
          end
          u.save!
          UserMailer.signed_up(u).deliver
          u
        end

        desc "Check your session is authorized as a user"
        get '/authorized' do
          authorize!
        end
      end
    end
  end
end
