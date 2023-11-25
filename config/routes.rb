# frozen_string_literal: true

Rails.application.routes.draw do
  namespace :tokens do
    resource :generation, only: :create
    resource :resend, only: :create
  end

  get 'up' => 'rails/health#show', as: :rails_health_check

  root 'main#index'
end
