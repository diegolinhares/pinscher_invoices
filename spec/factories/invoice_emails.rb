# frozen_string_literal: true

FactoryBot.define do
  factory :invoice_email do
    invoice
    email { ::Faker::Internet.email }
  end
end
