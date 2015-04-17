Rails.application.config.middleware.use OmniAuth::Builder do
  #require 'openid/store/filesystem'
  provider :facebook, ENV['FACEBOOK_APP_ID'], ENV['FACEBOOK_SECRET']
  #provider :openid, :store => OpenID::Store::Filesystem.new('/tmp')
  provider :github, ENV['GITHUB_ID'], ENV['GITHUB_SECRET'], scope: "user:email"
end
