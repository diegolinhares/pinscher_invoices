# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ::Api::V1::InvoicesController, type: :request do
  describe 'GET api/v1/invoices' do
    describe 'success' do
      specify 'filter by issue date' do
        # Arrange
        user = create(:user)
        invoice = create(:invoice, user:)
        token = create(:token, active: true, expires_at: 20.years.from_now, user:)
        token_value = authenticate_with_token(token.token_value)

        query_params = {
          'issue_date' => invoice.issue_date
        }

        # Act
        get api_v1_invoices_path(query_params), headers: { 'Authorization' => token_value }

        invoices = json_response(response)[:invoices]

        # Assert
        expect(response).to be_successful
        expect(invoices.first[:issue_date]).to eq(invoice.issue_date.to_s)
        expect(invoices.size).to eq(1)
      end

      specify 'filter by invoice number' do
        # Arrange
        user = create(:user)
        invoice = create(:invoice, user:)
        token = create(:token, active: true, expires_at: 20.years.from_now, user:)
        token_value = authenticate_with_token(token.token_value)

        query_params = {
          'invoice_number' => invoice.invoice_number
        }

        # Act
        get api_v1_invoices_path(query_params), headers: { 'Authorization' => token_value }

        invoices = json_response(response)[:invoices]

        # Assert
        expect(response).to be_successful
        expect(invoices.first[:invoice_number]).to eq(invoice.invoice_number)
        expect(invoices.size).to eq(1)
      end

      specify 'paginate by 3 and number of page 3' do
        # Arrange
        user = create(:user)
        token = create(:token, active: true, expires_at: 20.years.from_now, user:)
        token_value = authenticate_with_token(token.token_value)
        _invoices = create_list(:invoice, 12, user:)

        query_params = {
          'items' => 3,
          'page' => 3
        }

        # Act
        get api_v1_invoices_path(query_params), headers: { 'Authorization' => token_value }

        invoices = json_response(response)[:invoices]
        pagination = json_response(response)[:pagination]

        # Assert
        expect(response).to be_successful
        expect(pagination).to eq({ count: 12, items: 3, page: 3, pages: 4 })
        expect(invoices.size).to eq(3)
      end
    end

    describe 'failures' do
      specify 'expired token' do
        # Arrange
        user = create(:user)
        token = create(:token, active: true, expires_at: 20.years.ago, user:)
        token_value = authenticate_with_token(token.token_value)

        # Act
        get api_v1_invoices_path, headers: { 'Authorization' => token_value }

        # Assert
        expect(response).to be_unauthorized
        expect(json_response(response)).to eq({ message: 'Bad credentials' })
      end

      specify 'invalid token' do
        # Arrange
        token_value = authenticate_with_token('invalid_token')

        # Act
        get api_v1_invoices_path, headers: { 'Authorization' => token_value }

        # Assert
        expect(response).to be_unauthorized
        expect(json_response(response)).to eq({ message: 'Bad credentials' })
      end
    end
  end

  describe 'POST api/v1/invoices' do
    describe 'success' do
      specify 'create invoice' do
        # Arrange
        user = create(:user)
        token = create(:token, active: true, expires_at: 20.years.from_now, user:)
        token_value = authenticate_with_token(token.token_value)
        invoice = build(:invoice)

        params = {
          'invoice' => {
            'user_id' => user.id,
            'issue_date' => invoice.issue_date,
            'company' => invoice.company,
            'billing_to' => invoice.billing_to,
            'total_value' => invoice.total_value,
            'invoice_emails_attributes' => [
              { 'email' => 'email@example.com' },
              { 'email' => 'anotheremail@example.com' }
            ]
          }
        }

        allow(::Invoices::Pdf::GenerateTempfileJob).to receive(:perform_later)

        # Act
        post api_v1_invoices_path, params:, headers: { 'Authorization' => token_value }

        # Assert
        expect(response).to be_successful
        expect(json_response(response)[:company]).to eq(invoice.company)
      end
    end

    describe 'failures' do
      specify 'invoice with errors' do
        # Arrange
        user = create(:user)
        token = create(:token, active: true, expires_at: 20.years.from_now, user:)
        token_value = authenticate_with_token(token.token_value)
        invoice = build(:invoice)

        params = {
          'invoice' => {
            'user_id' => user.id,
            'issue_date' => invoice.issue_date,
            'company' => nil,
            'billing_to' => invoice.billing_to,
            'total_value' => invoice.total_value,
            'invoice_emails_attributes' => [
              { 'email' => 'email@example.com' },
              { 'email' => 'anotheremail@example.com' }
            ]
          }
        }

        post api_v1_invoices_path, params:, headers: { 'Authorization' => token_value }

        expect(response).to be_unprocessable
        expect(json_response(response)).to eq({ errors: { company: ["can't be blank"] } })
      end

      specify 'expired token' do
        # Arrange
        user = create(:user)
        token = create(:token, active: true, expires_at: 20.years.ago, user:)
        token_value = authenticate_with_token(token.token_value)

        params = {}

        # Act
        post api_v1_invoices_path, params:, headers: { 'Authorization' => token_value }

        # Assert
        expect(response).to be_unauthorized
        expect(json_response(response)).to eq({ message: 'Bad credentials' })
      end

      specify 'invalid token' do
        # Arrange
        token_value = authenticate_with_token('invalid_token')

        params = {}

        # Act
        post api_v1_invoices_path, params:, headers: { 'Authorization' => token_value }

        # Assert
        expect(response).to be_unauthorized
        expect(json_response(response)).to eq({ message: 'Bad credentials' })
      end
    end
  end

  describe 'GET api/v1/invoices/:id' do
    describe 'success' do
      specify 'user invoice' do
        user = create(:user)
        token = create(:token, active: true, expires_at: 20.years.from_now, user:)
        token_value = authenticate_with_token(token.token_value)
        invoice = create(:invoice, user:)

        get api_v1_invoice_path(invoice), headers: { 'Authorization' => token_value }

        expect(response).to be_successful
        expect(json_response(response)[:id]).to eq(invoice.id)
      end
    end

    describe 'failures' do
      specify 'invoice not found' do
        user = create(:user)
        token = create(:token, active: true, expires_at: 20.years.from_now, user:)
        token_value = authenticate_with_token(token.token_value)

        get api_v1_invoice_path(1), headers: { 'Authorization' => token_value }

        expect(response).to be_not_found
        expect(json_response(response)).to eq({ error: 'Not Found',
                                                message: 'The requested invoice could not be found.' })
      end

      specify 'expired token' do
        user = create(:user)
        token = create(:token, active: true, expires_at: 20.years.ago, user:)
        token_value = authenticate_with_token(token.token_value)
        invoice = create(:invoice, user:)

        get api_v1_invoice_path(invoice), headers: { 'Authorization' => token_value }

        expect(response).to be_unauthorized
        expect(json_response(response)).to eq({ message: 'Bad credentials' })
      end

      specify 'invalid token' do
        token_value = authenticate_with_token('invalid_token')

        get api_v1_invoice_path(1), headers: { 'Authorization' => token_value }

        expect(response).to be_unauthorized
        expect(json_response(response)).to eq({ message: 'Bad credentials' })
      end
    end
  end
end
