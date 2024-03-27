Rails.application.routes.draw do
  root 'home#index'
  # get 'policies/index'
  resources :policies, only: [:index, :new, :create]

  devise_for :users, controllers: {
    omniauth_callbacks: 'users/omniauth_callbacks'
  }

  # rails_health_check
  get "up" => "rails/health#show", as: :rails_health_check
end
