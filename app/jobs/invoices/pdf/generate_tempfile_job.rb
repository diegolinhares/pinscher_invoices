# frozen_string_literal: true

module Invoices
  module Pdf
    class GenerateTempfileJob < ::ApplicationJob
      queue_as :default

      # rubocop:disable Metrics/MethodLength
      def perform(invoice_id)
        input = {
          invoice_id:
        }

        GenerateTempfile.call(input) do |on|
          on.success do |data|
            log_generated_tempfile_message

            send_emails(data[:invoice], data[:pdf_path])
          end
          on.failure(:invoice_not_found) { log_not_found_message }
          on.unknown { raise _1.inspect }
        end
      end
      # rubocop:enable Metrics/MethodLength

      private

      def log_generated_tempfile_message
        logger.info('Generated tempfile')
      end

      def send_emails(invoice, pdf_path)
        invoice.invoice_emails.pluck(:email).each do |email|
          ::Invoices::PdfMailer.send_pdf(invoice, email, pdf_path).deliver_later
        end
      end

      def log_not_found_message
        logger.error('Invoice not found')
      end
    end
  end
end
