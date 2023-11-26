# frozen_string_literal: true

user = ::User.find_or_create_by!(email: 'elonmusk@pinscher.com')

::Token.find_or_create_by!(user:) do |token|
  token.token_value = '4f91348a9fe9936f785ee14d799ee4813a1e92dc'
  token.active = true
  token.expires_at = 20.years.from_now
end

if ::Invoice.count < 200
  200.times do
    ::Invoice.create!(
      user:,
      company: ::Faker::Company.name,
      billing_to: ::Faker::Company.name,
      total_value: ::Faker::Number.number(digits: 4),
      issue_date: ::Faker::Date.in_date_period,
      emails: [::Faker::Internet.email]
    )
  end
end
