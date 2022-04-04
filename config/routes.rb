# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :users,
             class_name: 'UserAccount',
             path_names: { sign_in: 'login', sign_out: 'logout', sign_up: 'signup' },
             controllers: { omniauth_callbacks: 'users/omniauth_callbacks',
                            registrations: 'users/registrations' }
  root 'home_pages#index'
  resources :books, only: %i[index show]
  resources :addresses, only: %i[new create]
end
