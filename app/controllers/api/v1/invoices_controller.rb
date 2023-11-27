# frozen_string_literal: true

module Api
  module V1
    class InvoicesController < ApplicationController
      include ::Pagy::Backend

      before_action :authenticate

      # rubocop:disable Metrics/MethodLength
      # rubocop:disable Metrics/AbcSize
      def index
        pagination_options = {
          page: params[:page],
          items: params[:items] || 10
        }

        input = {
          user_id: current_user.id,
          filters: {
            issue_date: params[:issue_date],
            invoice_number: params[:invoice_number]
          }
        }

        ::Invoices::List.call(input) do |on|
          on.success { render_invoices(_1[:invoices], pagination_options) }
          on.unknown { raise _1.inspect.errors }
        end
      end
      # rubocop:enable Metrics/MethodLength
      # rubocop:enable Metrics/AbcSize

      # rubocop:disable Metrics/MethodLength
      # rubocop:disable Metrics/AbcSize
      def create
        input = {
          issue_date: invoice_params[:issue_date],
          company: invoice_params[:company],
          billing_to: invoice_params[:billing_to],
          total_value: invoice_params[:total_value],
          invoice_emails_attributes: invoice_params[:invoice_emails_attributes],
          user_id: current_user.id
        }

        ::Invoices::Create.call(input) do |on|
          on.success do
            generate_invoice_pdf(_1[:invoice])
            render_invoice(_1[:invoice])
          end
          on.failure(:invalid) { render_invoice_errors(_1[:invoice]) }
          on.unknown { raise _1.inspect.errors }
        end
      end
      # rubocop:enable Metrics/MethodLength
      # rubocop:enable Metrics/AbcSize

      def show
        input = {
          invoice_id: params[:id],
          user_id: current_user.id
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

      def generate_invoice_pdf(invoice)
        ::Invoices::Pdf::GenerateTempfileJob.perform_later(invoice.id)
      end

      def render_invoices(invoices, pagination_options)
        pagy, invoices = pagy(invoices, **pagination_options)

        render json: {
          invoices:,
          pagination: {
            page: pagy.page,
            items: pagy.items,
            count: pagy.count,
            pages: pagy.pages
          }
        }
      end

      def render_invoice(invoice)
        render json: invoice, status: :ok
      end

      def render_invoice_errors(invoice)
        render json: { errors: invoice.errors }, status: :unprocessable_entity
      end

      def render_not_found
        error_message = {
          error: 'Not Found',
          message: 'The requested invoice could not be found.'
        }

        render json: error_message, status: :not_found
      end
    end
  end
end
