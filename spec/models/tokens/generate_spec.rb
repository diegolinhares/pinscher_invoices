# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Tokens::Generate, type: :use_case do
  describe 'failures' do
    specify 'email is invalid' do
      # Arrange
      input = {
        email: 'wrongemailformat'
      }

      # Act
      result = described_class.call(input)

      # Assert
      expect(result).to be_failure
      expect(result.type).to eq(:invalid_email)
    end

    specify 'token already exists' do
      # Arrange
      user = create(:user)
      _token = create(:token, user:, active: true)

      input = {
        email: user.email
      }

      # Act
      result = described_class.call(input)

      # Assert
      expect(result).to be_failure
      expect(result.type).to eq(:token_already_exists)
    end
  end

  describe 'success' do
    specify "email isn't registered yet" do
      # Arrange
      input = {
        email: ::Faker::Internet.email
      }

      # Act
      result = described_class.call(input)

      # Assert
      expect(result.success?).to be_truthy
      expect(result[:user]).to be_persisted
      expect(result[:user].token).to be_present
    end
  end
end
