# frozen_string_literal: true

module Checkout
  class DeliveriesController < BaseCheckoutController
    before_action :set_shipping_methods

    def edit; end

    def update
      if shipping_method_exists?
        @order.update(permitted_params)
        @order.payment_step! if @order.may_payment_step?
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

    def shipping_method_exists?
      ShippingMethod.find_by(id: params[:order][:shipping_method_id]).present?
    end

    def set_shipping_methods
      @shipping_methods = ShippingMethod.all.decorate
    end
  end
end
