Rails.application.routes.draw do
  mount Wordset::API => "/api"
end
