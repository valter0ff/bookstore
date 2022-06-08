# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  devise_scope :user do
    get 'checkout/login', to: 'checkouts#new'
    post 'checkout/login', to: 'checkouts#create'
    post 'checkout/sign_up', to: 'checkouts#fast_sign_up'
    get 'checkout/address', to: 'checkouts#address'
  end
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
  resource :cart, only: :show
  resources :cart_items, only: %i[show edit update destroy] do
    put :increment_book, on: :member
    put :decrement_book, on: :member
  end
  resources :orders do
    put :apply_coupon, on: :member
  end
  scope 'checkout' do
    get 'login', to: 'checkouts#login', as: :checkout_login
    get 'address', to: 'checkouts#address', as: :checkout_address
    patch 'save_adresses', to: 'checkouts#save_adresses', as: :checkout_save_adresses
    get 'delivery', to: 'checkouts#delivery', as: :checkout_delivery
  end
  scope 'settings' do
    resources :addresses, only: %i[new create update]
  end
  %w[404 422 500].each do |code|
    match "/#{code}", to: 'errors#show', code: code, via: :all
  end
end
