# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Invoice, type: :model do
  describe 'associations' do
    it { is_expected.to belong_to(:user) }
    it { is_expected.to have_many(:invoice_emails) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:company) }
    it { is_expected.to validate_presence_of(:billing_to) }
    it { is_expected.to validate_presence_of(:total_value_cents) }
  end
end
