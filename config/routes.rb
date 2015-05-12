Rails.application.routes.draw do
  devise_for :admins

  namespace :admin do
    get "/" => "dashboard#index"
  end

  root :to => redirect("/docs"), only_path: false
  mount Wordsets::API => "/api"
  mount GrapeSwaggerRails::Engine, at: "/docs"

  get "/auth/:provider/callback" => "auth#callback"

  post "/auth/:provider/create" => "auth#create"
end
