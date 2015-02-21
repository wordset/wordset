require 'pusher'

if Rails.env == "production"
  Pusher.url = "http://48d537b460788bef06f4:915af886678748771ce9@api.pusherapp.com/apps/108004"
else
  Pusher.url = "http://e8039c23fe140e473468:ec8d8cf1d07d87aa8496@api.pusherapp.com/apps/108005"
end
Pusher.logger = Rails.logger
