Rails.application.routes.draw do
  root 'home#index'
  # get 'policies/index'

  resources :policies

  devise_for :users, controllers: {
    omniauth_callbacks: 'users/omniauth_callbacks'
  }

  # rails_health_check
  get "up" => "rails/health#show", as: :rails_health_check
end
