# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :user_accounts, path_names: { sign_in: 'login', sign_out: 'logout', sign_up: 'signup' }
  root 'home_pages#index'
  resources :books, only: %i[index show]
end
