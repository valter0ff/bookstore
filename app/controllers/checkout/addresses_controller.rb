# frozen_string_literal: true

module Checkout
  class AddressesController < BaseCheckoutController
    def edit; end

    def update
      if current_user.update(permitted_params)
        @order.delivery_step! if @order.may_delivery_step?
        redirect_to edit_checkout_delivery_path, notice: I18n.t('checkout.addresses.edit.addresses_saved')
      else
        render :edit
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
