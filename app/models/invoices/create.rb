# frozen_string_literal: true

module Invoices
  class Create < ::Micro::Case
    attribute :issue_date, validates: { kind: ::Kind::String }
    attribute :company, validates: { kind: ::Kind::String }
    attribute :billing_to, validates: { kind: ::Kind::String }
    attribute :total_value, validates: { kind: ::Kind::String }
    attribute :invoice_emails_attributes, validates: { kind: ::Kind::Hash }
    attribute :user_id, validates: { kind: ::Kind::String }

    def call!
      create_invoice
    end

    private

    # rubocop:disable Metrics/MethodLength
    def create_invoice
      invoice = ::Invoice.new(
        issue_date:,
        company:,
        billing_to:,
        total_value:,
        invoice_emails_attributes:,
        user_id:
      )

      invoice.save

      return Failure(:invalid, result: { invoice: }) unless invoice.valid?

      Success(:ok, result: { invoice: })
    rescue ActiveRecord::RecordNotUnique
      invoice.errors.add(:base, 'Each email must be unique per invoice')

      Failure(:invalid, result: { invoice: })
    end
    # rubocop:enable Metrics/MethodLength
  end
end
