# frozen_string_literal: true

Rails.application.routes.draw do
  namespace :api, defaults: { format: :json } do
    resources :cards, only: %i[index show]
    resources :words, only: %i[index show create update]
  end

  namespace :admin do
    resources :cards, only: %i[index]
    resources :words, only: %i[index]
    root 'home#index'
  end

  resources :cards, only: %i[show], path: :c
  resources :cards, only: %i[show]

  root 'home#index'
end
