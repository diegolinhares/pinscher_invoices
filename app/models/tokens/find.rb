# frozen_string_literal: true

module Tokens
  class Find < ::Micro::Case
    attribute :token_value, validates: { kind: ::Kind::String }

    def call!
      find_token
        .then(:find_user)
    end

    private

    def find_token
      token = ::Token.find_by(token_value:, active: true)

      return Failure(:invalid_token) unless token

      return Failure(:expired_token) if token.expired?

      Success(:ok, result: { token: })
    end

    def find_user(token:, **)
      user = ::User.joins(:tokens).find_by(tokens: { id: token.id })

      Success(:ok, result: { user: })
    end
  end
end
