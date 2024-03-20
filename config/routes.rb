# frozen_string_literal: true

Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get 'up' => 'rails/health#show', as: :rails_health_check

  namespace :api do
    post 'checks', to: 'checks#github'
  end

  # Defines the root path route ("/")
  scope module: 'web' do
    post 'auth/:provider', to: 'auth#request', as: :auth_request
    delete 'auth/logout', to: 'auth#destroy'
    get 'auth/:provider/callback', to: 'auth#callback', as: :callback_auth

    resources :repositories, only: %i[index show new create] do
      scope module: 'repositories' do
        resources :checks, only: %i[show create]
      end
    end
    root 'home#index'
  end
end
