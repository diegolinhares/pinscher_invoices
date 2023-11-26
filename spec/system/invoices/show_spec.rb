# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Invoices::Show', type: :system, js: true do
  before do
    driven_by :selenium, using: :headless_chrome
  end

  context 'when user is logged in' do
    it 'displays the user invoice' do
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
      expect(page).to have_content('Invoice Details')
    end

    it 'redirects to the list of invoices and shows "Invoice not found" alert' do
      # Arrange
      user = create(:user)
      token = create(:token, user:, active: true, expires_at: 1.day.from_now)

      # Act
      visit root_path
      fill_in 'Token', with: token.token_value
      click_on 'Login'

      expect(page).to have_text('Invoices', wait: 3)

      visit invoice_path('non_existing_id')

      # Assert
      expect(page).to have_current_path(invoices_path)
      expect(page).to have_text('Invoice not found')
    end
  end
end
