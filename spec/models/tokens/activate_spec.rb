# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Tokens::Activate, type: :use_case do
  describe 'failures' do
    specify 'invalid token' do
      # Arrange
      input = {
        token_value: attributes_for(:token)[:token_value]
      }

      # Act
      result = described_class.call(input)

      # Assert
      expect(result).to be_failure
      expect(result.type).to eq(:invalid_token)
    end

    specify 'expired token' do
      # Arrange
      user = create(:user)
      token = create(:token, user:, active: true, expires_at: 1.day.ago)

      input = {
        token_value: token.token_value
      }

      # Act
      result = described_class.call(input)

      # Assert
      expect(result).to be_failure
      expect(result.type).to eq(:expired_token)
    end
  end

  describe 'success' do
    specify 'valid token' do
      # Arrange
      user = create(:user)
      token = create(:token, user:, active: true, expires_at: 1.day.from_now)

      input = {
        token_value: token.token_value
      }

      # Act
      result = described_class.call(input)

      # Assert
      expect(result.success?).to be_truthy
      expect(result[:user]).to be_present
    end
  end
end
