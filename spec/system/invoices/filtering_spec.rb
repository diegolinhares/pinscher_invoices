# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Invoices::Filtering', type: :system, js: true do
  before do
    driven_by :selenium, using: :chrome
  end

  context 'when user is logged in' do
    it 'filter the invoices by issue date' do
      # Arrange
      user = create(:user)
      token = create(:token, user:, active: true, expires_at: 1.day.from_now)

      invoices = create_list(:invoice, 3, user:) do |invoice|
        invoice.issue_date = rand(1..30).days.ago
        invoice.save
      end

      # Act
      visit root_path
      fill_in 'Token', with: token.token_value
      click_on 'Login'

      fill_in 'Issue Date', with: invoices.first.issue_date
      find('input[name="issue_date"]').send_keys(:enter)

      expect(page).to have_content(invoices.first.invoice_number)

      rows = page.all('tbody tr')
      number_of_filtered_invoices = rows.size

      # Assert
      expect(number_of_filtered_invoices).to eq(1)
    end

    it 'filter the invoices by invoice number' do
      # Arrange
      user = create(:user)
      token = create(:token, user:, active: true, expires_at: 1.day.from_now)

      invoices = create_list(:invoice, 3, user:)

      # Act
      visit root_path
      fill_in 'Token', with: token.token_value
      click_on 'Login'

      fill_in 'Invoice Number', with: invoices.first.invoice_number
      find('input[name="invoice_number"]').send_keys(:enter)

      expect(page).to have_content(invoices.first.invoice_number)

      rows = page.all('tbody tr')
      number_of_filtered_invoices = rows.size

      # Assert
      expect(number_of_filtered_invoices).to eq(1)
    end

    it 'filter the invoices by issue date and invoice number' do
      # Arrange
      user = create(:user)
      token = create(:token, user:, active: true, expires_at: 1.day.from_now)

      invoices = create_list(:invoice, 3, user:) do |invoice|
        invoice.issue_date = rand(1..30).days.ago
        invoice.save
      end

      # Act
      visit root_path
      fill_in 'Token', with: token.token_value
      click_on 'Login'

      fill_in 'Issue Date', with: invoices.first.issue_date
      fill_in 'Invoice Number', with: invoices.first.invoice_number
      find('input[name="invoice_number"]').send_keys(:enter)

      expect(page).to have_content(invoices.first.invoice_number)

      rows = page.all('tbody tr')
      number_of_filtered_invoices = rows.size

      # Assert
      expect(number_of_filtered_invoices).to eq(1)
    end
  end
end
