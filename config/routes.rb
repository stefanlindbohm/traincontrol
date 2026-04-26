# frozen_string_literal: true

Rails.application.routes.draw do
  root to: redirect('locomotives')

  resources :locomotives, only: %i[index show new create update]
  resources :interlocks, only: %i[index new create] do
    resources :turnouts, only: %i[new create update]
  end

  namespace :setup do
    root to: 'navigation#show'
    resource :command_station, only: %i[show create update], path: 'command-station'
  end
end
