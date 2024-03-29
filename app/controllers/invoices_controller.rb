# frozen_string_literal: true

class InvoicesController < ::ApplicationController
  include ::Pagy::Backend

  before_action :authenticate_user!

  def new
    invoice = ::Invoice.new
    invoice.invoice_emails.build

    render 'invoices/new', locals: { invoice: }
  end

  # rubocop:disable Metrics/MethodLength
  # rubocop:disable Metrics/AbcSize
  def create
    input = {
      issue_date: invoice_params[:issue_date],
      company: invoice_params[:company],
      billing_to: invoice_params[:billing_to],
      total_value: invoice_params[:total_value],
      invoice_emails_attributes: invoice_params[:invoice_emails_attributes],
      user_id: ::Current.user.id
    }

    ::Invoices::Create.call(input) do |on|
      on.success do
        generate_invoice_pdf(_1[:invoice])
        redirect_invoice(_1[:invoice])
      end
      on.failure(:invalid) { render_form_errors(_1[:invoice]) }
      on.unknown { raise _1.inspect.errors }
    end
  end
  # rubocop:enable Metrics/MethodLength
  # rubocop:enable Metrics/AbcSize

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

  def show
    input = {
      invoice_id: params[:id],
      user_id: ::Current.user.id
    }

    ::Invoices::Show.call(input) do |on|
      on.success { render_invoice(_1[:invoice]) }
      on.failure(:invoice_not_found) { render_not_found }
      on.unknown { raise _1.inspect.errors }
    end
  end

  private

  def invoice_params
    params.require(:invoice).permit(:issue_date, :company, :billing_to, :total_value,
                                    invoice_emails_attributes: %i[id email _destroy])
  end

  def render_invoices(invoices)
    pagy, invoices = pagy(invoices, items: 10, link_extra: 'data-turbo-action="advance"')

    render 'invoices/index', locals: { invoices:, pagy: }
  end

  def render_invoice(invoice)
    render 'invoices/show', locals: { invoice: }
  end

  def render_not_found
    flash[:alert] = 'Invoice not found'

    redirect_to invoices_path, status: :found
  end

  def redirect_invoice(invoice)
    flash[:success] = 'Invoice was successfully created'

    redirect_to invoice_path(invoice), status: :found
  end

  def render_form_errors(invoice)
    render 'invoices/new', locals: { invoice: }, status: :unprocessable_entity
  end

  def generate_invoice_pdf(invoice)
    ::Invoices::Pdf::GenerateTempfileJob.perform_later(invoice.id)
  end
end
