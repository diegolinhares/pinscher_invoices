# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ::TokenMailer, type: :mailer do
  describe 'send_token' do
    it 'renders the headers' do
      user = create(:user)
      _token = create(:token, user:)

      mail = described_class.send_token(user)

      expect(mail.subject).to eq('Your access token')
      expect(mail.to).to eq([user.email])
      expect(mail.from).to eq(['from@example.com'])
    end

    it 'renders the body' do
      user = create(:user)
      _token = create(:token, user:)

      mail = described_class.send_token(user)

      expect(mail.body.encoded).to match("Here's your access token:")
    end
  end
end
