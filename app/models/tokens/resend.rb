# frozen_string_literal: true

module Tokens
  class Resend < ::Micro::Case
    attribute :email, validates: { kind: ::Kind::String }

    def call!
      find_user
        .then(:find_current_token)
    end

    private

    def find_user
      user = ::User.find_by(email:)

      return Failure(:user_not_found) unless user

      Success(:ok, result: { user: })
    end

    def find_current_token(user:, **)
      token_value = ::SecureRandom.hex(58)

      ::Token.create(token_value:, user:, expires_at: 24.hours.from_now)

      Success(:ok, result: { user: })
    end
  end
end
