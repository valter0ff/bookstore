# frozen_string_literal: true

module Checkout
  class DeliveriesController < BaseCheckoutController
    before_action :set_shipping_methods

    def edit; end

    def update
      shipping_method = ShippingMethod.find_by(id: params[:order][:shipping_method_id])
      if shipping_method.present?
        @order.update(permitted_params)
        redirect_to edit_checkout_payment_path, notice: I18n.t('checkout.deliveries.edit.shipping_method_saved')
      else
        flash.now[:alert] = I18n.t('checkout.deliveries.edit.choose_method')
        render :edit
      end
    end

    private

    def permitted_params
      params.require(:order).permit(:shipping_method_id)
    end

    def set_shipping_methods
      @shipping_methods = ShippingMethod.all.decorate
    end
  end
end
