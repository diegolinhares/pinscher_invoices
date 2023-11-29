# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Invoices::List, type: :use_case do
  describe 'success' do
    specify 'filter only by issue date' do
      # Arrange
      user = create(:user)
      invoice = create(:invoice, user:, issue_date: 1.day.ago)

      create(:invoice, user:, issue_date: 2.days.ago)

      input = {
        user_id: user.id,
        filters: {
          issue_date: invoice.issue_date,
          invoice_number: ''
        }
      }

      # Act
      result = described_class.call(input)

      # Assert
      expect(result.success?).to be_truthy
      expect(result[:invoices].size).to eq(1)
    end

    specify 'filter only by invoice number' do
      # Arrange
      user = create(:user)

      create(:invoice, user:, invoice_number: 1)
      create(:invoice, user:, invoice_number: 2)

      input = {
        user_id: user.id,
        filters: {
          issue_date: '',
          invoice_number: 2
        }
      }

      # Act
      result = described_class.call(input)

      # Assert
      expect(result.success?).to be_truthy
      expect(result[:invoices].size).to eq(1)
    end

    specify 'filter by both' do
      # Arrange
      user = create(:user)
      invoice = create(:invoice, user:)

      input = {
        user_id: user.id,
        filters: {
          issue_date: invoice.issue_date,
          invoice_number: invoice.invoice_number
        }
      }

      # Act
      result = described_class.call(input)

      # Assert
      expect(result.success?).to be_truthy
      expect(result[:invoices].size).to eq(1)
    end
  end
end
