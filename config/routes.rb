Unirepu::Application.routes.draw do
  root :to => "home#index"
  devise_for :users, :controllers => { :registrations => "registrations", :omniauth_callbacks => "users/omniauth_callbacks" }
  #devise_for :users, :controllers => {:registrations => "registrations"}
  resources :users
end