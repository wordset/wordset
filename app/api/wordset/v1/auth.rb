module Wordset
  module V1
    class Auth < Grape::API
      include Wordset::V1::Defaults

      resource :users do
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

        desc "Register New User"
        params do
          requires :username, :type => String, :desc => "Username"
          requires :email, :type => String, :desc => "User email"
          requires :password, :type => String, :desc => "User password"
        end
        post '/' do
          email = params[:email]
          password = params[:password]

          User.create!(email: email,
                          password: password,
                          password_confirmation: password,
                          username: params[:username])
          { status: 'ok', message: 'Please confirm email address' }
        end

        desc "Check your session is authorized as a user"
        get '/authorized' do
          authorize!
        end
      end
    end
  end
end
