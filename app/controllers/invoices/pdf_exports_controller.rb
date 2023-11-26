# frozen_string_literal: true

module Invoices
  class PdfExportsController < ::ApplicationController
    before_action :authenticate_user!

    def show
      input = {
        invoice_id: params[:id],
        user_id: ::Current.user.id
      }

      Pdf::Export.call(input) do |on|
        on.success { render_pdf(_1[:pdf]) }
        on.failure(:invoice_not_found) { return_not_found }
        on.unknown { raise _1.inspect.errors }
      end
    end

    private

    def return_not_found
      head :not_found
    end

    def render_pdf(pdf)
      respond_to do |format|
        format.pdf do
          send_data pdf.render, filename: 'invoice.pdf',
                                type: 'application/pdf',
                                disposition: 'inline'
        end
      end
    end
  end
end
