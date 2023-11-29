# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Invoices::Create, type: :use_case do
  describe 'success' do
    specify 'creating a valid invoice' do
      # Arrange
      user = create(:user)
      email = ::Faker::Internet.email
      email_attributes = { '0' => { email: } }

      input = {
        user_id: user.id,
        issue_date: ::Faker::Date.backward(days: 14),
        company: ::Faker::Company.name,
        billing_to: ::Faker::Company.name,
        total_value: ::Faker::Number.decimal,
        invoice_emails_attributes: email_attributes
      }

      # Act
      result = described_class.call(input)

      # Assert
      expect(result.success?).to be_truthy
      expect(result[:invoice]).to be_persisted
      expect(result[:invoice].invoice_emails.first.email).to eq(email)
    end
  end

  describe 'failures' do
    specify 'with invalid email' do
      # Arrange
      user = create(:user)
      email_attributes = { '0' => { email: 'invalidemail' } }

      input = {
        user_id: user.id,
        issue_date: ::Faker::Date.backward(days: 14),
        company: ::Faker::Company.name,
        billing_to: ::Faker::Company.name,
        total_value: ::Faker::Number.decimal,
        invoice_emails_attributes: email_attributes
      }

      # Act
      result = described_class.call(input)

      # Assert
      expect(result).to be_failure
      expect(result[:invoice].errors.full_messages).to eq(['Invoice emails email is invalid'])
    end

    specify 'with missing email' do
      # Arrange
      user = create(:user)
      email_attributes = { '0' => { email: '' } }

      input = {
        user_id: user.id,
        issue_date: ::Faker::Date.backward(days: 14),
        company: ::Faker::Company.name,
        billing_to: ::Faker::Company.name,
        total_value: ::Faker::Number.decimal,
        invoice_emails_attributes: email_attributes
      }

      # Act
      result = described_class.call(input)

      # Assert
      expect(result).to be_failure
      expect(result[:invoice].errors.full_messages).to include("Invoice emails email can't be blank")
    end

    specify 'with duplicate email for the same invoice' do
      # Arrange
      user = create(:user)
      email = ::Faker::Internet.email
      email_attributes = {
        '0' => { email:  },
        '1' => { email:  }
      }

      input = {
        user_id: user.id,
        issue_date: ::Faker::Date.backward(days: 14),
        company: ::Faker::Company.name,
        billing_to: ::Faker::Company.name,
        total_value: ::Faker::Number.decimal,
        invoice_emails_attributes: email_attributes
      }

      # Act
      result = described_class.call(input)

      # Assert
      expect(result).to be_failure
      expect(result[:invoice].errors.full_messages).to eq(['Each email must be unique per invoice'])
    end

    specify 'without company' do
      # Arrange
      user = create(:user)
      input = {
        user_id: user.id,
        issue_date: ::Faker::Date.backward(days: 14),
        company: '',
        billing_to: ::Faker::Company.name,
        total_value: ::Faker::Number.decimal,
        invoice_emails_attributes: { '0' => { email: ::Faker::Internet.email } }
      }

      # Act
      result = described_class.call(input)

      # Assert
      expect(result).to be_failure
      expect(result[:invoice].errors.full_messages).to include("Company can't be blank")
    end

    specify 'without issue date' do
      # Arrange
      user = create(:user)
      input = {
        user_id: user.id,
        issue_date: '',
        company: ::Faker::Company.name,
        billing_to: ::Faker::Company.name,
        total_value: ::Faker::Number.decimal,
        invoice_emails_attributes: { '0' => { email: ::Faker::Internet.email } }
      }

      # Act
      result = described_class.call(input)

      # Assert
      expect(result).to be_failure
      expect(result[:invoice].errors.full_messages).to include("Issue date can't be blank")
    end

    specify 'with invalid total value' do
      # Arrange
      user = create(:user)
      email_attributes = { '0' => { email: ::Faker::Internet.email } }

      input = {
        user_id: user.id,
        issue_date: ::Faker::Date.backward(days: 14),
        company: ::Faker::Company.name,
        billing_to: ::Faker::Company.name,
        total_value: 'invalid',
        invoice_emails_attributes: email_attributes
      }

      # Act
      result = described_class.call(input)

      # Assert
      expect(result).to be_failure
      expect(result[:invoice].errors.full_messages).to include('Total value is not a number')
    end
  end
end
