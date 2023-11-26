# frozen_string_literal: true

class InvoiceEmail < ApplicationRecord
  encrypts :email, deterministic: true

  belongs_to :invoice

  validates :email,
            presence: true,
            uniqueness: {
              case_sensitive: false,
              scope: :invoice_id,
              message: 'Each email must be unique per invoice'
            },
            format: { with: ::URI::MailTo::EMAIL_REGEXP }

  normalizes :email, with: ->(value) { value.strip }
end
