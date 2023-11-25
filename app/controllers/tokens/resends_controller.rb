# frozen_string_literal: true

module Tokens
  class ResendsController < ::ApplicationController
    def create
      input = {
        email: params[:email]
      }

      ::Tokens::Resend.call(input) do |on|
        on.success { deliver_email_later_for(_1[:user]) }
        on.failure(:user_not_found) { render_user_not_found_message }
        on.unknown { raise _1.inspect.errors }
      end
    end

    private

    def deliver_email_later_for(user)
      ::TokenMailer.send_token(user).deliver_later

      respond_to do |format|
        format.turbo_stream do
          flash.now[:success] = 'An email will be sent to you shortly with the new link to access the application.'

          render turbo_stream: [
            turbo_stream.update('remote_modal', ''),
            turbo_stream.update('flash', partial: 'application/flash_messages')
          ]
        end
      end
    end

    def render_user_not_found_message
      respond_to do |format|
        format.turbo_stream do
          flash.now[:alert] = 'User not found'

          render turbo_stream: turbo_stream.update('flash', partial: 'application/flash_messages')
        end
      end
    end
  end
end
