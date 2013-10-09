Unirepu::Application.routes.draw do
  get "dashboard/index"
  root :to => "home#index"
  match "/users/auth/:provider/callback" => "sessions#create", via: [:get, :post]

  devise_for :users, :controllers => {:registrations => "registrations"}
  resources :users
end
