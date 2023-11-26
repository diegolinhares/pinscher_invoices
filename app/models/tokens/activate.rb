# frozen_string_literal: true

module Tokens
  class Activate < ::Micro::Case
    attribute :token_value, validates: { kind: ::Kind::String }

    def call!
      find_token
        .then(:find_user)
        .then(:deactivate_old_token)
        .then(:activate_new_token)
    end

    private

    def find_token
      token = ::Token.find_by(token_value:)

      return Failure(:invalid_token) unless token

      return Failure(:expired_token) if token.expired?

      Success(:ok, result: { token: })
    end

    def find_user(token:, **)
      user = ::User.joins(:tokens).find_by(tokens: { id: token.id })

      return Failure(:user_not_found) unless user

      Success(:ok, result: { user: })
    end

    def deactivate_old_token(user:, **)
      ::Token.find_by(user:, active: true)&.update(active: false)

      Success(:ok)
    end

    def activate_new_token(token:, user:, **)
      ::Token.update(token.id, active: true)

      Success(:ok, result: { user: })
    end
  end
end
