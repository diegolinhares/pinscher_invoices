# frozen_string_literal: true

module Api
  module V1
    class ApplicationController < ::ActionController::Base
      before_action :authenticate

      attr_reader :current_user

      private

      def authenticate
        authenticate_user_with_token || handle_bad_authentication
      end

      def authenticate_user_with_token
        authenticate_with_http_token do |token, _options|
          ::Tokens::Find.call(token_value: token) do |on|
            on.success { define_current_user(_1[:user]) }
            on.failure { handle_bad_authentication }
          end
        end
      end

      def define_current_user(user)
        @current_user = user
      end

      def handle_bad_authentication
        render json: { message: 'Bad credentials' }, status: :unauthorized
      end
    end
  end
end
