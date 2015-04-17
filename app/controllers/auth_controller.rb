class AuthController < ApplicationController

  def callback
    data = env["omniauth.auth"]
    provider = IdentityProvider.find_or_create_by(name: data["provider"])
    cred = data["credentials"]
    token = cred["token"]
    identity = provider.find_with_token(token)
    if identity.nil?
      if data["info"]["verified"] && (user = User.where(email: data["info"]["email"]).first)
        identity = user.identities.find_or_initialize_by(identity_provider: provider)
      else
        identity = provider.identities.build
      end
    end

    identity.token = token
    identity.expires_at = cred["expires_at"]
    identity.data = data
    identity.save!
    if identity.user.nil?
      redirect_to ENV["UI_HOST"] + "/auth/#{provider.name}/setup/#{data["credentials"]["token"]}"
    else
      redirect_to_login(identity.user)
    end
  end

  def create
    provider = IdentityProvider.find_or_create_by(name: params[:provider])
    identity = provider.find_with_token(params[:token])
    data = identity.data
    if identity.user.nil?
      info = data["info"]
      extra = data["extra"]["raw_info"]
      user = identity.build_user(email: info["email"],
                                 confirmed_at: Time.now,
                                 confirmation_token: provider.name,
                                 identity_image_url: info["image"])
      if params[:acceptTos]
        user.accept_tos_at = Time.now
        user.accept_tos_ip = env["REMOTE_ADDR"]
      end
      if params[:emailOptIn]
        user.email_opt_in_at = Time.now
        user.email_opt_in_ip = env['REMOTE_ADDR']
      end

      if provider.name == "facebook"
        user.username = params[:username]
      elsif provider.name == "github"
        user.username = info["nickname"]
        user.site_url = extra["blog"]
        user.location = extra["location"]
      end
      user.generate_random_password!
      user.save!
    end

    render json: {username: user.username, auth_key: user.auth_key}
  end

 private

  def redirect_to_login(user)
    redirect_to ENV["UI_HOST"] + "/auth/do/#{user.username}/#{user.auth_key}"
  end



end
