# frozen_string_literal: true

FactoryBot.define do
  factory :token do
    user
    token_value { Faker::Alphanumeric.alphanumeric(number: 58) }
    expires_at { '2023-11-24 16:08:28' }
    active { false }
  end
end
