module Wordset
  module V1
    module Defaults
      extend ActiveSupport::Concern

      included do
        version 'v1', using: :path, vendor: 'wordset'
        default_format :json
        format :json
        formatter :json, Grape::Formatter::ActiveModelSerializers

        helpers do
          def permitted_params
            @permitted_params ||= declared(params, include_missing: false)
          end

          def default_serializer_options
            {only: params[:only], except: params[:except]}
          end

          def logger
            Rails.logger
          end

          def authorize!
            authenticate
            error!('401 Unauthorized', 401) unless current_user
          end

          def authenticate
            return @user if @user
            header = request.headers["Authorization"]
            return false unless header
            pair = request.headers["Authorization"].split(" ").last
            username, key = pair.split(":")
            if key == nil
              return false
            end
            u = User.where(username: username, auth_key: key).first
            puts u.inspect
            if u.nil?
              return false
            end
            @user = u
          end

          def current_user
            @user
          end
        end

        rescue_from Mongoid::Errors::Validations do |e|
          response = {errors: e.document.errors}
          rack_response response.to_json, 422
        end

        #rescue_from Mongoid::RecordNotFound do |e|
        #  error_response(message: e.message, status: 404)
        #end

        #rescue_from Mongoid::RecordInvalid do |e|
        #  error_response(message: e.message, status: 422)
        #end
      end
    end
  end
end
