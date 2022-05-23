# frozen_string_literal: true

class CartsController < ClientController
  before_action :find_coupon, only: :update

  def show
    @order = @order.decorate
    @cart_items = @order.cart_items.includes(book: :pictures)
  end

  def update
    if @coupon.try(:active?)
      @order.update(coupon: @coupon)
      redirect_to cart_path, notice: I18n.t('carts.show.coupon_applied')
    else
      redirect_to cart_path, alert: I18n.t('carts.show.coupon_rejected')
    end
  end

  private

  def cart_params
    params.require(:order).permit(coupon: :code)
  end

  def find_coupon
    @coupon = Coupon.find_by(code: cart_params[:coupon][:code])
  end
end
