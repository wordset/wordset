
require 'pusher'

if Rails.env != "production"
  require 'pusher-fake/support/base'
  PusherFake.configure do |configuration|
    configuration.logger  = Rails.logger
    configuration.verbose = true
  end
  config = PusherFake.configuration
  ENV["PUSHER_URL"] = "http://PUSHER_API_KEY:PUSHER_API_SECRET@#{config.web_options[:host]}:#{config.web_options[:port]}/PUSHER_APP_ID"
  puts ENV["PUSHER_URL"]
end

Pusher.url = ENV["PUSHER_URL"]
Pusher.logger = Rails.logger
