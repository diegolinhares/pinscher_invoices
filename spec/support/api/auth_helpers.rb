# frozen_string_literal: true

module Api
  module AuthHelpers
    def authenticate_with_token(token)
      ActionController::HttpAuthentication::Token.encode_credentials(token)
    end
  end
end

RSpec.configure do |config|
  config.include ::Api::AuthHelpers, type: :request
end
