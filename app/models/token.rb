# frozen_string_literal: true

class Token < ApplicationRecord
  encrypts :token_value, deterministic: true

  belongs_to :user, inverse_of: :token

  validates :token_value, presence: true, uniqueness: true
  validates :expires_at, presence: true

  def expired?
    expires_at < ::Time.zone.now
  end
end
