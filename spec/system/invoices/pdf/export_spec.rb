# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Invoices::Pdf::Export', type: :system, js: true do
  before do
    driven_by :selenium, using: :headless_chrome
  end

  context 'when user is logged in' do
    it 'checks pdf export link correct' do
      # Arrange
      user = create(:user)
      token = create(:token, user:, active: true, expires_at: 1.day.from_now)
      invoice = create(:invoice, user:)
      create(:invoice_email, invoice:)

      # Act
      visit root_path

      fill_in 'Token', with: token.token_value
      click_on 'Login'

      expect(page).to have_text('Invoices', wait: 3)

      visit invoice_path(invoice)

      # Assert
      expect(page).to have_link('Download PDF', href: invoices_pdf_export_path(invoice, format: :pdf))
    end
  end
end
