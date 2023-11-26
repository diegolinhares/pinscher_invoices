# frozen_string_literal: true

module InvoicesHelper
  include ::Pagy::Frontend

  def invoice_number_formatter(number)
    number.to_s.rjust(4, '0')
  end
end
