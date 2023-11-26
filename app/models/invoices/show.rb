# frozen_string_literal: true

module Invoices
  class Show < ::Micro::Case
    attribute :invoice_id, validates: { kind: ::Kind::String }
    attribute :user_id, validates: { kind: ::Kind::String }

    def call!
      find_invoice
    end

    private

    def find_invoice
      invoice = ::Invoice.find_by(id: invoice_id, user_id:)

      return Failure(:invoice_not_found) unless invoice

      Success(:ok, result: { invoice: })
    end
  end
end
