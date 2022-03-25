# frozen_string_literal: true

Rails.application.routes.draw do
  root 'home_pages#index'
  resources :books, only: %i[index show]
end
