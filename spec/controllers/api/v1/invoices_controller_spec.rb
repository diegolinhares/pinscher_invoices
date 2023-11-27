# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ::Api::V1::InvoicesController, type: :request do
  describe 'GET /invoices/:id' do
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
