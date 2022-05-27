# frozen_string_literal: true

class ApplicationDecorator < Draper::Decorator
  include Draper::LazyHelpers

  private

  def price_with_currency(price)
    number_to_currency(price, unit: Constants::Shared::CURRENCY, format: Constants::Shared::CURRENCY_FORMAT)
  end
end
