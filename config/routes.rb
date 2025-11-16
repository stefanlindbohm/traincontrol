# frozen_string_literal: true

Rails.application.routes.draw do
  root to: redirect('locomotives')

  resources :locomotives, only: %i[index show update]
end
