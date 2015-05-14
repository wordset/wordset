
if Rails.env.test? || Rails.env.cucumber?
  CarrierWave.configure do |config|
    config.storage = :file
    config.enable_processing = false
  end
elsif Rails.env.production?
  CarrierWave.configure do |config|
    config.storage = :fog
    config.fog_provider = 'fog/aws'                        # required
    config.fog_credentials = {
      provider:               'AWS',
      aws_access_key_id:      ENV["AWS_ACCESS_KEY_ID"],                        # required
      aws_secret_access_key:  ENV["AWS_SECRET_ACCESS_KEY"]
    }
    config.fog_directory = "wordset-#{Rails.env}"
  end
else
  CarrierWave.configure do |config|
    config.storage = :file
  end
end
