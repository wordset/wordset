module Wordset
  module V1
    class Auth < Grape::API
      include Wordset::V1::Defaults

      desc "Get User Auth Token"
      params do
        requires :username, type: String
        requires :password, type: String
      end
      post '/login' do
        username = params[:username]
        password = params[:password]

        user = User.where(username: username).first
        if user && user.valid_password?(password)
          {username: user.username,
            auth_key: user.auth_key}
          else
            error!({:error_code => 404, :error_message => "Invalid email or password"}, 401)
          end
        end

      resource :users do

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
          end
        end
        post '/', serializer: NewUserSerializer do
          user_params = params[:user]
          email = user_params[:email]
          password = user_params[:password]

          User.create!(email: email,
                       password: password,
                       password_confirmation: password,
                       username: user_params[:id])
        end

        desc "Check your session is authorized as a user"
        get '/authorized' do
          authorize!
        end
      end
    end
  end
end
