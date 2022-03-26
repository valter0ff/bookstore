# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :users,
             class_name: 'UserAccount',
             path_names: { sign_in: 'login', sign_out: 'logout', sign_up: 'signup' },
             controllers: { omniauth_callbacks: 'users/omniauth_callbacks' }
  root 'home_pages#index'
  resources :books, only: %i[index show]
end
