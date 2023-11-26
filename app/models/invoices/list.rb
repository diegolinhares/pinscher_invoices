# frozen_string_literal: true

module Invoices
  class List < ::Micro::Case
    attribute :user_id, validates: { kind: ::Kind::String }
    attribute :filters, validates: { kind: ::Kind::Hash }

    def call!
      remove_blank_filters
        .then(:find_invoices)
    end

    private

    RemoveBlankValue = ->(_, value) { value.blank? }

    def remove_blank_filters
      filters.reject!(&RemoveBlankValue)

      Success(:ok)
    end

    def find_invoices
      invoices = ::Invoice.where(user_id:)
      invoices = invoices.where(**filters) if filters.present?
      invoices = invoices.order(:issue_date)

      Success(:ok, result: { invoices: })
    end
  end
end
