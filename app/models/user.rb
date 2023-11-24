# frozen_string_literal: true

class User < ::ApplicationRecord
  encrypts :email, deterministic: true

  validates :email,
            presence: true,
            uniqueness: { case_sensitive: false },
            format: { with: ::URI::MailTo::EMAIL_REGEXP }

  normalizes :email, with: ->(value) { value.downcase.strip }
end
