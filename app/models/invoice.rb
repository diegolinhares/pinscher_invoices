# frozen_string_literal: true

class Invoice < ApplicationRecord
  belongs_to :user

  validates :company, :billing_to, :total_value_cents, :emails, presence: true
end
