# frozen_string_literal: true

Rails.application.routes.draw do
  root to: redirect('locomotives')

  resources :locomotives, only: %i[index show update]

  namespace :setup do
    root to: 'navigation#show'
    resource :general_settings, only: %i[show], path: 'general'
  end
end
