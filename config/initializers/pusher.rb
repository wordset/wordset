

require 'pusher'
if Rails.env == "production"
  Pusher.url = ENV["PUSHER_URL"]
  Pusher.logger = Rails.logger
else
  Pusher.app_id = "wordset"
  Pusher.key = "key"
  Pusher.secret = "mybigsecret"
  require 'pusher-fake/support/base'
end
