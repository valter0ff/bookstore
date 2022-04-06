# frozen_string_literal: true

module AddressesHelper
  def choose_path(address)
    address.id.present? ? address_path(address) : addresses_path
  end

  def choose_method(address)
    address.id.present? ? :put : :post
  end
end
