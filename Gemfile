source 'https://rubygems.org'
ruby '2.2.2'


# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails'
# Use mysql as the database for Active Record
gem 'mongoid'

gem "grape", '0.9.0'
gem "grape-active_model_serializers"
gem 'grape-swagger', github: 'tim-vandecasteele/grape-swagger'
gem 'grape-swagger-rails', github: 'BrandyMint/grape-swagger-rails'
gem 'grape-raketasks'

gem 'rails_12factor', group: :production
gem 'rack-ssl-enforcer'

gem 'devise'
gem 'omniauth-facebook'
gem 'omniauth-github', :github => 'intridea/omniauth-github'
gem 'omniauth-google-oauth2'


gem 'active_model_serializers'#, github: "rails-api/active_model_serializers"
gem 'mongoid-serializer'
gem 'aasm'
gem 'validate_url'
gem 'postmark-rails'
gem 'pusher'

gem 'fog'
gem 'sitemap_generator'

gem 'carrierwave', github: 'carrierwaveuploader/carrierwave'
gem 'carrierwave-mongoid'
gem 'rmagick'

gem 'nested_form_fields'

gem 'levenshtein-ffi', :require => 'levenshtein'

# Use SCSS for stylesheets
gem 'sass-rails', '~> 5.0'
gem 'haml'
gem 'jquery-rails'
gem 'coffee-rails'

gem 'newrelic_rpm', '~> 3.8'
gem 'newrelic-grape'
gem 'newrelic_moped', '~> 0'

gem "rack-cors", require: "rack/cors"
gem 'gravtastic'

gem 'bson'

gem "passenger"

group :production do
  gem "gibbon"
end

group :development do
  gem "better_errors"
  gem "meta_request"
  gem "quiet_assets"
  gem "letter_opener"
  gem 'web-console', '~> 2.0'
end

group :development, :test do
  gem "pry-nav"
  gem "pry-rails"
  gem "pry-stack_explorer"
  gem "pry-theme"

  gem 'dotenv-rails'
  gem "codeclimate-test-reporter", require: nil

  gem 'airborne'

  #gem "capybara"
  #gem "capybara-screenshot"
  gem "database_cleaner"
  gem "factory_girl_rails"
  gem "faker"
  gem "pusher-fake"
  #gem "poltergeist"
  gem "rspec-rails"
  gem 'spring-commands-rspec'
  gem 'guard-rspec'
  #gem 'rb-fsevent' if `uname` =~ /Darwin/
  #gem "rubocop"
  #gem "shoulda-matchers"
  #gem "spring-commands-rspec"
  gem 'mongoid-rspec'
  gem 'mongoid-tree'

  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
end
