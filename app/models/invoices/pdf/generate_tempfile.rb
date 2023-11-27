# frozen_string_literal: true

module Invoices
  module Pdf
    class GenerateTempfile < ::Micro::Case
      attribute :invoice_id, validates: { kind: ::Kind::String }

      def call!
        find_invoice
          .then(:generate_temp_pdf)
      end

      private

      def find_invoice
        invoice = ::Invoice.find_by(id: invoice_id)

        return Failure(:invoice_not_found) unless invoice

        Success(:ok, result: { invoice: })
      end

      def generate_temp_pdf(invoice:, **)
        pdf = Generator.call(invoice:)

        temp_pdf = Tempfile.new(["invoice_#{invoice.id}", '.pdf'], Rails.root.join('tmp'))
        pdf.render_file(temp_pdf.path)

        Success(:ok, result: { invoice:, pdf_path: temp_pdf.path })
      end
    end
  end
end
