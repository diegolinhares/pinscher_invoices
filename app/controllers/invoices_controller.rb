# frozen_string_literal: true

class InvoicesController < ::ApplicationController
  include ::Pagy::Backend

  before_action :authenticate_user!

  # rubocop:disable Metrics/MethodLength
  def index
    input = {
      user_id: ::Current.user.id,
      filters: {
        issue_date: params[:issue_date],
        invoice_number: params[:invoice_number]
      }
    }

    ::Invoices::List.call(input) do |on|
      on.success { render_invoices(_1[:invoices]) }
      on.unknown { raise _1.inspect.errors }
    end
  end
  # rubocop:enable Metrics/MethodLength

  private

  def render_invoices(invoices)
    pagy, invoices = pagy(invoices, items: 10, link_extra: 'data-turbo-action="advance"')

    render 'invoices/index', locals: { invoices:, pagy: }
  end
end
