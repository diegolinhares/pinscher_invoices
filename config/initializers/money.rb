# frozen_string_literal: true

::Money.locale_backend = nil
::Money.rounding_mode = BigDecimal::ROUND_HALF_EVEN

::MoneyRails.configure do |config|
  config.default_currency = :usd
end
