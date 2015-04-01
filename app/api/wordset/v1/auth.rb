module Wordset
  module V1
    class Auth < Grape::API
      include Wordset::V1::Defaults

      namespace :auth do

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

        desc "Check your session is authorized as a user"
        get '/authorized' do
          authorize!
          true
        end

        desc "pusher configuration options"
        get '/pusher_configuration' do
          {key: PusherFake.configuration.key,
           connection: PusherFake.configuration.to_options({})
          }
        end
      end
    end
  end
end
