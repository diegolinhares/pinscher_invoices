# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Authentication', type: :system, js: true do
  include ::EmailSpec::Helpers
  include ::EmailSpec::Matchers

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

    it 'clicks on token link in email' do
      # Arrange
      user = create(:user)
      _token = create(:token, user:, active: true)

      # Act
      visit root_path
      fill_in 'Email', with: user.email
      click_on 'Generate'
      click_on 'Confirm'

      expect(page).to have_text('An email will be sent to you shortly with the new link to access the application.',
                                wait: 3)

      open_email(user.email)

      token_url = links_in_email(current_email).first
      visit token_url

      # Assert
      expect(page).to have_text('Signed in successfully')
    end

    it 'signs in the user when the token is valid' do
      # Arrange
      user = create(:user)
      token = create(:token, user:, active: true, expires_at: 1.day.from_now)

      # Act
      visit root_path
      fill_in 'Token', with: token.token_value
      click_on 'Login'

      # Assert
      expect(page).to have_current_path(invoices_path)
      expect(page).to have_text('Signed in successfully')
    end

    it 'renders an error when the token is invalid' do
      # Arrange
      user = create(:user)
      token = create(:token, user:, active: false, expires_at: 1.day.from_now)

      # Act
      visit root_path
      fill_in 'Token', with: token.token_value
      click_on 'Login'

      # Assert
      expect(page).to have_current_path(root_path)
      expect(page).to have_text('Invalid or expired token')
    end

    it 'renders an error when the token is expired' do
      # Arrange
      user = create(:user)
      token = create(:token, user:, active: false, expires_at: 2.days.ago)

      # Act
      visit root_path
      fill_in 'Token', with: token.token_value
      click_on 'Login'

      # Assert
      expect(page).to have_current_path(root_path)
      expect(page).to have_text('Invalid or expired token')
    end
  end

  context 'when user is logged in' do
    it 'signs in the user when the token is valid' do
      # Arrange
      user = create(:user)
      token = create(:token, user:, active: true, expires_at: 1.day.from_now)

      # Act
      visit root_path
      fill_in 'Token', with: token.token_value
      click_on 'Login'
      click_on 'Logout'

      # Assert
      expect(page).to have_current_path(root_path)
      expect(page).to have_text('Signed out successfully')
    end
  end
end
