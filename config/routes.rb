Rails.application.routes.draw do
  root 'home#index'
  # get 'policies/index'

  resources :policies

  devise_for :users, controllers: {
    omniauth_callbacks: 'users/omniauth_callbacks'
  }

  # stripe
  resources :payments
  post 'payments/create'
  get 'payments/success'
  get 'payments/cancel'

  # rails_health_check
  get "up" => "rails/health#show", as: :rails_health_check
end
