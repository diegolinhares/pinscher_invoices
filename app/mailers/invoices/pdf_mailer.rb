# frozen_string_literal: true

module Invoices
  class PdfMailer < ::ApplicationMailer
    def send_pdf(invoice, email, pdf_path)
      attachments['invoice.pdf'] = ::File.read(pdf_path)

      mail to: email, subject: 'Your invoice' do |format|
        format.html do
          render 'invoices/pdf_mailer/send_pdf', locals: { invoice: }
        end
      end
    end
  end
end
