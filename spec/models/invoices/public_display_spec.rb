# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Invoices::PublicDisplay, type: :use_case do
  describe 'success' do
    specify 'display existent invoice' do
      # Arrange
      invoice = create(:invoice)
      input = { invoice_id: invoice.id }

      # Act
      result = described_class.call(input)

      # Assert
      expect(result.success?).to be_truthy
      expect(result[:invoice]).to eq(invoice)
    end
  end

  describe 'failures' do
    specify "not found error when invoice doesn't exists" do
      # Arrange
      input = { invoice_id: 'nonexistent' }

      # Act
      result = described_class.call(input)

      # Assert
      expect(result.failure?).to be_truthy
      expect(result.type).to eq(:invoice_not_found)
    end
  end
end
