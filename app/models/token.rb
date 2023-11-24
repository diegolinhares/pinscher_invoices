# frozen_string_literal: true

class Token < ApplicationRecord
  encrypts :token_value, deterministic: true

  belongs_to :user

  validates :token_value, presence: true, uniqueness: true
  validates :expires_at, presence: true
end
