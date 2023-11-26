# frozen_string_literal: true

module Invoices
  module Pdf
    class Generator
      def self.call(invoice:, builder: Prawn::Document.new)
        builder.text "Invoice ##{invoice.id}"
        builder.text "Issue date: #{invoice.issue_date}"
        builder.text "Company: #{invoice.company}"
        builder.text "Billing to: #{invoice.billing_to}"
        builder.text "Total value: #{invoice.total_value}"
        builder
      end
    end
  end
end
