Unirepu::Application.routes.draw do
  root :to => "home#index"
  match "/auth/:provider/callback" => "sessions#create", via: [:get, :post]

  devise_for :users, :controllers => {:registrations => "registrations"}
  resources :users
end