# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Invoices::Show, type: :use_case do
  describe 'success' do
    it 'finds an existing invoice' do
      # Arrange
      user = create(:user)
      invoice = create(:invoice, user:)

      input = {
        user_id: user.id,
        invoice_id: invoice.id
      }

      # Act
      result = described_class.call(input)

      # Assert
      expect(result.success?).to be_truthy
      expect(result[:invoice]).to eq(invoice)
    end

    it 'returns an error if the invoice is not found' do
      # Arrange
      user = create(:user)

      input = {
        user_id: user.id,
        invoice_id: 'non_existing_id'
      }

      # Act
      result = described_class.call(input)

      # Assert
      expect(result.failure?).to be_truthy
      expect(result.type).to eq(:invoice_not_found)
    end
  end
end
