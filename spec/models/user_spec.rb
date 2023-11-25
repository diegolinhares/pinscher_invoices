# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'associations' do
    it { is_expected.to have_one(:token) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:email) }

    it { is_expected.to allow_value('user@example.com').for(:email) }
    it { is_expected.not_to allow_value('user@').for(:email) }
    it { is_expected.not_to allow_value('user').for(:email) }

    it { is_expected.to have_db_index(:email).unique(true) }
    it { is_expected.to have_db_column(:email).of_type(:string) }

    context 'when creating a user with an email that already exists' do
      it 'does not allow creating another user with the same email' do
        # Arrange
        create(:user, email: 'elonmusk@pinscher.com')

        new_user = build(:user, email: 'elonmusk@pinscher.com')

        # Act
        new_user.valid?

        # Assert
        expect(new_user.errors[:email]).to include('has already been taken')
      end
    end
  end

  describe '#token_value' do
    context 'when the user has a token' do
      it 'returns the token value' do
        # Arrange
        user = create(:user)
        token = create(:token, user:)

        # Act/Assert
        expect(user.token_value).to eq(token.token_value)
      end
    end

    context 'when the user does not have a token' do
      it 'raises an ::Module::DelegationError' do
        # Arrange
        user = create(:user)

        # Act/Assert
        expect { user.token_value }.to raise_error(::Module::DelegationError)
      end
    end
  end
end
