# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Tokens::Resend, type: :use_case do
  describe 'failures' do
    specify 'user not found' do
      # Arrange
      input = {
        email: 'nonexistentemail@example.com'
      }

      # Act
      result = described_class.call(input)

      # Assert
      expect(result).to be_failure
      expect(result.type).to eq(:user_not_found)
    end
  end

  describe 'success' do
    specify 'finds user and generates new token' do
      # Arrange
      user = create(:user)
      _existing_token = create(:token, user:, active: true)

      input = {
        email: user.email
      }

      # Act
      result = described_class.call(input)

      # Assert
      expect(result).to be_success
      expect(result[:user]).to eq(user)
      expect(user.token).to be_present
    end
  end
end
