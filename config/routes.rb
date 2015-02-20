Rails.application.routes.draw do
  root :to => redirect("/docs"), only_path: false
  mount Wordset::API => "/api"
  mount GrapeSwaggerRails::Engine, at: "/docs"
end
