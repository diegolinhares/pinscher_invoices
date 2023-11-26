# frozen_string_literal: true

class InvoiceEmailsController < ::ApplicationController
  def new
    invoice_email = ::InvoiceEmail.new

    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: turbo_stream.append('invoice-emails', partial: 'invoices/email',
                                                                   locals: { invoice_email: })
      end

      format.html do
        render partial: 'invoices/email', locals: { invoice_email: }
      end
    end
  end
end
