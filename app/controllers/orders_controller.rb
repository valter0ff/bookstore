# frozen_string_literal: true

class OrdersController < ClientController
  before_action :authenticate_user!

  def index
    @orders = Orders::FilterOrdersService.call(current_user.id, params[:filter_by])
                                         .includes(%i[cart_items coupon])
                                         .order(:completed_at)
                                         .decorate
  end

  def show
    @current_order = current_user.orders.find(params[:id]).decorate
    @cart_items = @current_order.cart_items.includes(book: :pictures)
  end

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
