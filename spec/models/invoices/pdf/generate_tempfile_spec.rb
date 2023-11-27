# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Invoices::Pdf::GenerateTempfile, type: :use_case do
  describe 'call!' do
    context 'when the invoice exists' do
      it 'successfully finds the invoice and generates a temp PDF' do
        # Arrange
        invoice = create(:invoice)

        # Act
        result = described_class.call(invoice_id: invoice.id)

        # Assert
        expect(result.success?).to be_truthy
        expect(result[:pdf_path]).to be_present
      end
    end

    context 'when the invoice does not exist' do
      it 'fails to find the invoice' do
        # Arrange
        nonexistent_invoice_id = 'nonexistent'

        # Act
        result = described_class.call(invoice_id: nonexistent_invoice_id)

        # Assert
        expect(result.failure?).to be_truthy
        expect(result.type).to eq(:invoice_not_found)
      end
    end
  end
end
