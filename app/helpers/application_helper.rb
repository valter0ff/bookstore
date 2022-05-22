# frozen_string_literal: true

module ApplicationHelper
  include Pagy::Frontend

  def number_with_currency(price)
    number_to_currency(price, unit: Constants::Shared::CURRENCY, format: Constants::Shared::CURRENCY_FORMAT)
  end
end
