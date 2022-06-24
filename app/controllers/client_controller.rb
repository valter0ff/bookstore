# frozen_string_literal: true

class ClientController < ApplicationController
  include Pagy::Backend

  before_action :set_all_categories
  before_action :check_order
  before_action :set_total_books_count
  before_action :store_user_location!, if: :storable_location?

  private

  def set_all_categories
    @categories = Category.all
  end

  def check_order
    @order ||= current_user.try(:current_order) || session_order
  end

  def set_order
    @order = Orders::SetOrderService.call(current_user, session)
  end

  def set_total_books_count
    @total_books_count = @order.present? ? @order.cart_items.sum(&:books_count) : 0
  end

  def store_user_location!
    store_location_for(:user, request.fullpath)
  end

  def storable_location?
    request.get? && is_navigational_format? && !devise_controller? && !request.xhr?
  end

  def after_sign_in_path_for(resource)
    set_order if check_order
    stored_location_for(resource) || super
  end

  def session_order
    Order.find_by(id: session[:order_id])
  end
end
