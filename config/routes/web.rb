# frozen_string_literal: true

Rails.application.routes.draw do
  namespace :invoices do
    resources :public_displays, only: :show
    resources :pdf_exports, only: :show
  end

  namespace :tokens do
    resource :generation, only: :create
    resource :resend, only: :create
  end

  resources :invoices, only: %i[new create index show]
  resources :invoice_emails, only: %i[new], param: :index

  resource :session, only: %i[create show destroy], param: :token

  root 'main#index'
end
