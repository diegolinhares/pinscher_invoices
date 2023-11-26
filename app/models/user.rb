# frozen_string_literal: true

class User < ::ApplicationRecord
  encrypts :email, deterministic: true

  has_many :tokens, dependent: :delete_all

  has_one :token, -> { where(active: false).order(created_at: :desc) }, inverse_of: :user, dependent: :destroy

  validates :email,
            presence: true,
            uniqueness: { case_sensitive: false },
            format: { with: ::URI::MailTo::EMAIL_REGEXP }

  normalizes :email, with: ->(value) { value.downcase.strip }

  delegate :token_value, to: :token, prefix: false, allow_nil: false
end
