# frozen_string_literal: true

module Invoices
  class PublicDisplaysController < ::ApplicationController
    def show
      input = {
        invoice_id: params[:id]
      }

      PublicDisplay.call(input) do |on|
        on.success { render_invoice(_1[:invoice]) }
        on.failure(:invoice_not_found) { redirect_to_root_path }
        on.unknown { raise _1.inspect.errors }
      end
    end

    private

    def render_invoice(invoice)
      render 'invoices/show', locals: { invoice: }
    end

    def redirect_to_root_path
      redirect_to root_path, alert: 'Invoice not found'
    end
  end
end
