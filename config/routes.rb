# frozen_string_literal: true

Rails.application.routes.draw do
  draw :api
  draw :web

  get 'up' => 'rails/health#show', as: :rails_health_check
end
