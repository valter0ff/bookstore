# frozen_string_literal: true

module Checkout
  class AddressesController < BaseCheckoutController
    def new; end

    def update
      if current_user.update(permitted_params)
        redirect_to new_checkout_delivery_path, notice: I18n.t('checkout.addresses.new.addresses_saved')
      else
        render :new
      end
    end

    private

    def addresses_params
      params.require(:user_account)
            .permit(:use_billing_address,
                    billing_address_attributes: %i[first_name last_name address city zip country_code phone],
                    shipping_address_attributes: %i[first_name last_name address city zip country_code phone])
    end

    def permitted_params
      return addresses_params unless addresses_params[:use_billing_address] == 'true'

      addresses_params.except(:shipping_address_attributes)
    end
  end
end
