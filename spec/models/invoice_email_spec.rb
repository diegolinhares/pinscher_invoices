# frozen_string_literal: true

require 'rails_helper'

RSpec.describe InvoiceEmail, type: :model do
  describe 'associations' do
    it { is_expected.to belong_to(:invoice) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:email) }

    it 'validates uniqueness of email scoped to invoice_id with a custom message' do
      # Arrange
      invoice = create(:invoice)

      create(:invoice_email, email: 'unique@example.com', invoice:)

      duplicate = build(:invoice_email, email: 'unique@example.com', invoice:)

      # Act
      duplicate.valid?

      # Assert
      expect(duplicate.errors[:email]).to include('Each email must be unique per invoice')
    end
  end
end
