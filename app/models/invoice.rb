# frozen_string_literal: true

class Invoice < ApplicationRecord
  encrypts :company, :billing_to, :emails

  belongs_to :user

  validates :issue_date, :company, :billing_to, :total_value_cents, :emails, presence: true

  monetize :total_value_cents
end
