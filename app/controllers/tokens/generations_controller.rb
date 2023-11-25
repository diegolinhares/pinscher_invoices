# frozen_string_literal: true

module Tokens
  class GenerationsController < ::ApplicationController
    def create
      email = params[:email]

      input = {
        email:
      }

      ::Tokens::Generate.call(input) do |on|
        on.success { deliver_email_later_for(_1[:user]) }
        on.failure(:invalid_email) { render_invalid_email_message }
        on.failure(:token_already_exists) { render_token_already_exists_modal(email) }
        on.unknown { raise _1.inspect.errors }
      end
    end

    private

    def deliver_email_later_for(user)
      ::TokenMailer.send_token(user).deliver_later

      respond_to do |format|
        format.turbo_stream do
          flash.now[:success] = 'An email will be sent to you shortly with a link to access the application.'

          render turbo_stream: turbo_stream.update('flash', partial: 'application/flash_messages')
        end
      end
    end

    def render_invalid_email_message
      respond_to do |format|
        format.turbo_stream do
          flash.now[:alert] = 'Invalid email'

          render turbo_stream: turbo_stream.update('flash', partial: 'application/flash_messages')
        end
      end
    end

    def render_token_already_exists_modal(email)
      respond_to do |format|
        format.turbo_stream do
          render turbo_stream: turbo_stream.update('remote_modal', partial: 'main/forms/existent_token',
                                                                   locals: { email: })
        end
      end
    end
  end
end
