require 'pusher'

if Rails.env == "production"
  Pusher.url = ENV["PUSHER_URL"]
else
  Pusher.url = "http://e8039c23fe140e473468:ec8d8cf1d07d87aa8496@api.pusherapp.com/apps/108005"
end
Pusher.logger = Rails.logger
