# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Token, type: :model do
  describe 'associations' do
    it { is_expected.to belong_to(:user) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:token_value) }
    it { is_expected.to validate_presence_of(:expires_at) }

    context 'when creating a token with a value that already exists' do
      it 'does not allow creating another token with the same value' do
        # Arrange
        existent_token = create(:token)

        new_token = build(:token, token_value: existent_token.token_value, user: existent_token.user)

        # Act
        new_token.valid?

        # Assert
        expect(new_token.errors[:token_value]).to include('has already been taken')
      end
    end
  end

  describe '#expired?' do
    context 'when the token has expired' do
      it 'returns true' do
        # Arrange
        user = create(:user)
        token = create(:token, user:, expires_at: 24.hours.from_now)

        # Act/Assert
        travel_to 2.days.from_now do
          expect(token.expired?).to be_truthy
        end
      end
    end

    context 'when the token has not expired' do
      it 'returns false' do
        # Arrange
        user = create(:user)
        token = create(:token, user:, expires_at: 24.hours.from_now)

        # Act/Assert
        travel_to 20.minutes.from_now do
          expect(token.expired?).to be_falsey
        end
      end
    end
  end
end
