# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Invoices::PublicDisplay', type: :system, js: true do
  before do
    driven_by :selenium, using: :headless_chrome
  end

  it 'displays the user invoice' do
    # Arrange
    user = create(:user)
    invoice = create(:invoice, user:)

    # Act
    visit invoices_public_display_path(invoice)

    # Assert
    expect(page).to have_content(invoice.company)
    expect(page).to have_content(invoice.billing_to)
  end

  it 'redirects to the list of invoices and shows "Invoice not found" alert' do
    # Arrange
    id = 'wrong-id'

    # Act
    visit invoices_public_display_path(id)

    # Assert
    expect(page).to have_current_path(root_path)
    expect(page).to have_text('Invoice not found')
  end
end
