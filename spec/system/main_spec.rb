# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Main', type: :system, js: true do
  before do
    driven_by :selenium, using: :headless_chrome
  end

  context 'when user is not logged in' do
    it 'displays a success message with the link to access the application' do
      # Arrange
      email = 'elonmusk@pinscher.com'

      # Act
      visit root_path
      fill_in 'Email', with: email
      click_on 'Generate'

      # Assert
      expect(page).to have_text('An email will be sent to you shortly with a link to access the application.')
    end

    it 'displays a modal to confirm a new token generation' do
      # Arrange
      user = create(:user)
      _token = create(:token, user:, active: true)

      # Act
      visit root_path
      fill_in 'Email', with: user.email
      click_on 'Generate'
      click_on 'Confirm'

      # Assert
      expect(page).to have_text('An email will be sent to you shortly with the new link to access the application.')
    end
  end
end
