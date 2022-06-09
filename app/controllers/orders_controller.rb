# frozen_string_literal: true

class OrdersController < ClientController
  def apply_coupon
    @coupon = Coupon.find_by(code: order_params[:coupon][:code])
    if @coupon.try(:active?)
      @order.update(coupon: @coupon)
      redirect_to cart_path, notice: I18n.t('orders.coupon_applied')
    else
      redirect_to cart_path, alert: I18n.t('orders.coupon_rejected')
    end
  end

  private

  def order_params
    params.require(:order).permit(coupon: :code)
  end
end
