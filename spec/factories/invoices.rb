# frozen_string_literal: true

FactoryBot.define do
  factory :invoice do
    issue_date { ::Faker::Date.in_date_period }
    company { ::Faker::Company.name }
    billing_to { ::Faker::Company.name }
    total_value_cents { ::Faker::Number.number(digits: 4) }
    user
  end
end
