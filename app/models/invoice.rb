# frozen_string_literal: true

class Invoice < ApplicationRecord
  encrypts :company, :billing_to

  belongs_to :user

  has_many :invoice_emails, dependent: :delete_all
  accepts_nested_attributes_for :invoice_emails, allow_destroy: true

  validates :issue_date, :company, :billing_to, :total_value_cents, presence: true

  monetize :total_value_cents
end
