# frozen_string_literal: true

module Tokens
  class Generate < ::Micro::Case
    attribute :email, validates: { kind: ::Kind::String }

    def call!
      find_or_create_user
        .then(:find_current_token)
    end

    private

    def find_or_create_user
      user = ::User.find_or_create_by(email:)

      return Failure(:invalid_email) unless user.valid?

      Success(:ok, result: { user: })
    end

    def find_current_token(user:, **)
      token = ::Token.find_by(user:, active: true)

      return Failure(:token_already_exists) if token

      token_value = ::SecureRandom.hex(58)

      ::Token.create(token_value:, user:, expires_at: 24.hours.from_now)

      Success(:ok, result: { user:, token_value: })
    end
  end
end
