# frozen_string_literal: true

module Api
  module V1
    class InvoicesController < ApplicationController
      before_action :authenticate

      def show
        input = {
          invoice_id: params[:id],
          user_id: current_user.id
        }

        ::Invoices::Show.call(input) do |on|
          on.success { render_invoice(_1[:invoice]) }
          on.failure(:invoice_not_found) { render_not_found }
          on.unknown { raise _1.inspect.errors }
        end
      end

      private

      def render_invoice(invoice)
        render json: invoice, status: :ok
      end

      def render_not_found
        error_message = {
          error: 'Not Found',
          message: 'The requested invoice could not be found.'
        }

        render json: error_message, status: :not_found
      end
    end
  end
end
