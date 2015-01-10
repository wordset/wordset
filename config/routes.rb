Rails.application.routes.draw do
  mount Wordset::API => "/api"
  mount GrapeSwaggerRails::Engine, at: "/docs"
end
