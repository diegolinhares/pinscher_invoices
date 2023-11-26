# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ::Invoices::Pdf::Export, type: :use_case do
  describe 'call' do
    context 'when the invoice exists and belongs to the user' do
      it 'successfully finds the invoice and generates a PDF' do
        # Arrange
        user = create(:user)
        invoice = create(:invoice, user:)

        input = {
          invoice_id: invoice.id,
          user_id: user.id
        }

        # Act
        result = described_class.call(input)

        # Assert
        expect(result).to be_success
        expect(result[:pdf]).to be_a(::Prawn::Document)
      end
    end

    context 'when the invoice does not exist' do
      it 'fails to find the invoice' do
        # Arrange
        user = create(:user)

        input = {
          invoice_id: 'nonexistent',
          user_id: user.id
        }

        # Act
        result = described_class.call(input)

        # Assert
        expect(result).to be_failure
        expect(result.type).to eq(:invoice_not_found)
      end
    end

    context 'when the user_id does not match' do
      it 'fails to find the invoice' do
        # Arrange
        user = create(:user)
        another_user = create(:user)
        invoice = create(:invoice, user:)

        input = {
          invoice_id: invoice.id,
          user_id: another_user.id
        }

        # Act
        result = described_class.call(input)

        # Assert
        expect(result).to be_failure
        expect(result.type).to eq(:invoice_not_found)
      end
    end
  end
end
