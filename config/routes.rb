Rails.application.routes.draw do
  devise_for :admins

  namespace :admin do
    get "/" => "dashboard#index", as: :dashboard

    resources :posts do
      member do
        post "publish"
      end
    end

    resources :quizzes do
      member do
        post "publish"
      end
    end
  end

  root :to => redirect("/docs"), only_path: false
  mount Wordsets::API => "/api"
  mount GrapeSwaggerRails::Engine, at: "/docs"

  get "/auth/:provider/callback" => "auth#callback"

  post "/auth/:provider/create" => "auth#create"
end
