# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  devise_for :users,
             class_name: 'UserAccount',
             path_names: { sign_in: 'login', sign_out: 'logout', sign_up: 'signup' },
             controllers: { omniauth_callbacks: 'users/omniauth_callbacks',
                            registrations: 'users/registrations' }
  root 'home_pages#index'
  resources :books, only: %i[index show] do
    resources :reviews, only: %i[create]
    resources :cart_items, only: %i[create]
  end
  resources :orders do
    resources :cart_items, only: %i[show edit update destroy]
  end
  scope '/settings' do
    resources :addresses, only: %i[new create update]
  end
  %w[404 422 500].each do |code|
    match "/#{code}", to: 'errors#show', code: code, via: :all
  end
end
