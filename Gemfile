source 'https://rubygems.org'
ruby '2.1.5'


# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.2.0'
# Use mysql as the database for Active Record
gem 'mongoid'

gem "grape", '0.9.0'
gem "grape-active_model_serializers"
gem 'grape-swagger', github: 'tim-vandecasteele/grape-swagger'
gem 'grape-swagger-rails', github: 'BrandyMint/grape-swagger-rails'
gem 'grape-raketasks'

gem 'rails_12factor', group: :production

gem 'devise'

gem 'active_model_serializers'
gem 'mongoid-serializer'
gem 'aasm'
gem 'validate_url'

# Use SCSS for stylesheets
gem 'sass-rails', '~> 5.0'

gem 'appsignal'

gem "rack-cors", require: "rack/cors"

# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
#gem 'jbuilder', '~> 2.0'
# bundle exec rake doc:rails generates the API under doc/api.
#gem 'sdoc', '~> 0.4.0', group: :doc
gem 'bson'

gem 'thin'

# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use Unicorn as the app server
# gem 'unicorn'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

group :development do
  gem "better_errors"
  gem "meta_request"
  gem "quiet_assets"
end

group :development, :test do
  gem "pry-nav"
  gem "pry-rails"
  gem "pry-stack_explorer"
  gem "pry-theme"
  gem 'mongoid-tree'

  #gem "capybara"
  #gem "capybara-screenshot"
  gem "database_cleaner"
  gem "factory_girl_rails"
  gem "faker"
  #gem "poltergeist"
  gem "rspec-rails"
  #gem "rubocop"
  #gem "shoulda-matchers"
  #gem "spring-commands-rspec"
  gem 'mongoid-rspec'

  # Access an IRB console on exception pages or by using <%= console %> in views
  gem 'web-console', '~> 2.0'

  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
end
