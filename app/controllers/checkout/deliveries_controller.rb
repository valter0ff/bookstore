# frozen_string_literal: true

module Checkout
  class DeliveriesController < BaseCheckoutController
    before_action :set_shipping_methods

    def new; end

    def update
      shipping_method = ShippingMethod.find_by(id: params[:order][:shipping_method_id])
      if shipping_method.present?
        @order.update(permitted_params)
        redirect_to new_checkout_payment_path, notice: I18n.t('checkout.deliveries.new.shipping_method_saved')
      else
        flash.now[:alert] = I18n.t('checkout.deliveries.new.choose_method')
        render :new
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
