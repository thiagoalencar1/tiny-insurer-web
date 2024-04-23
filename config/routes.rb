Rails.application.routes.draw do
  # home
  root 'home#index'

  # devise
  devise_for :users, controllers: {
    omniauth_callbacks: 'users/omniauth_callbacks'
  }

  # policies
  resources :policies

  # stripe
  resources :payments, only: [:new, :create]
  get 'payments/success'
  get 'payments/cancel'

  # websocket / payments confirmations
  mount ActionCable.server => '/cable'
  post "/confirm_payment", to: "payments#confirm_payment"

  # rails_health_check
  get "up" => "rails/health#show", as: :rails_health_check
end
