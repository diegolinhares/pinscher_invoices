# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Invoices::Creation', type: :system, js: true do
  before do
    driven_by :selenium, using: :headless_chrome
  end

  context 'when user is logged in' do
    it 'creates a new invoice with only one email' do
      # Arrange
      user = create(:user)
      token = create(:token, user:, active: true, expires_at: 1.day.from_now)

      # Act
      visit root_path

      fill_in 'Token', with: token.token_value
      click_on 'Login'

      click_on 'New Invoice'

      fill_in 'Issue date', with: '2021-01-01'
      fill_in 'Company', with: 'Test Company'
      fill_in 'Billing to', with: 'Test Customer'
      fill_in 'Total value', with: '1000'
      fill_in 'Email', with: 'test@example.com'
      click_on 'Submit'

      # Assert
      expect(page).to have_content('Invoice was successfully created')
      expect(page).to have_current_path(invoice_path(Invoice.last), ignore_query: true)
      expect(Invoice.last.invoice_emails.count).to eq(1)
    end

    it 'creates a new invoice with two different emails' do
      # Arrange
      user = create(:user)
      token = create(:token, user:, active: true, expires_at: 1.day.from_now)

      # Act
      visit root_path

      fill_in 'Token', with: token.token_value
      click_on 'Login'

      click_on 'New Invoice'

      fill_in 'Issue date', with: '2021-01-01'
      fill_in 'Company', with: 'Test Company'
      fill_in 'Billing to', with: 'Test Customer'
      fill_in 'Total value', with: '1000'
      fill_in 'Email', with: 'test@example.com'

      click_on 'Add another email'

      expect(page).to have_selector(
        'input[name^="invoice[invoice_emails_attributes]"][id^="invoice_invoice_emails_attributes"]', count: 2
      )

      second_email_field = all('input[type="text"][id^="invoice_invoice_emails_attributes_"]')[1]
      second_email_field.fill_in with: 'test2@example.com'

      click_on 'Submit'

      # Assert
      expect(page).to have_content('Invoice was successfully created')
      expect(page).to have_current_path(invoice_path(Invoice.last), ignore_query: true)
      expect(Invoice.last.invoice_emails.count).to eq(2)
    end

    it 'display an error when creating a new invoice with two emails, one being a duplicate' do
      # Arrange
      user = create(:user)
      token = create(:token, user:, active: true, expires_at: 1.day.from_now)

      # Act
      visit root_path

      fill_in 'Token', with: token.token_value
      click_on 'Login'

      click_on 'New Invoice'

      fill_in 'Issue date', with: '2021-01-01'
      fill_in 'Company', with: 'Test Company'
      fill_in 'Billing to', with: 'Test Customer'
      fill_in 'Total value', with: '1000'
      fill_in 'Email', with: 'test@example.com'

      click_on 'Add another email'

      expect(page).to have_selector(
        'input[name^="invoice[invoice_emails_attributes]"][id^="invoice_invoice_emails_attributes"]', count: 2
      )

      second_email_field = all('input[type="text"][id^="invoice_invoice_emails_attributes_"]')[1]
      second_email_field.fill_in with: 'test@example.com'

      click_on 'Submit'

      # Assert
      expect(page).to have_content('Each email must be unique per invoice')
    end

    it 'display an error when creating a new invoice with a non-numeric total value' do
      # Arrange
      user = create(:user)
      token = create(:token, user:, active: true, expires_at: 1.day.from_now)

      # Act
      visit root_path

      fill_in 'Token', with: token.token_value
      click_on 'Login'

      click_on 'New Invoice'

      fill_in 'Issue date', with: '2021-01-01'
      fill_in 'Company', with: 'Test Company'
      fill_in 'Billing to', with: 'Test Customer'
      fill_in 'Total value', with: 'InvalidValue'
      fill_in 'Email', with: 'test@example.com'
      click_on 'Submit'

      # Assert
      expect(page).to have_content('Total value is not a number')
    end
  end
end
