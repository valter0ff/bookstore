# frozen_string_literal: true

module Checkout
  class PaymentsController < BaseCheckoutController
    def edit; end

    def update
      if @order.update(permitted_params)
        redirect_to checkout_confirm_path, notice: I18n.t('checkout.payments.edit.credit_card_saved')
      else
        render :edit
      end
    end

    private

    def permitted_params
      params.require(:order).permit(credit_card_attributes: %i[number holder_name expiry_date cvv_code])
    end
  end
end
