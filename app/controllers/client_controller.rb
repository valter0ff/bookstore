# frozen_string_literal: true

class ClientController < ApplicationController
  include Pagy::Backend

  before_action :set_all_categories
  before_action :set_order
  before_action :set_total_books_count

  private

  def set_all_categories
    @categories = Category.all
  end

  def set_order
    @order = Orders::SetOrderService.call(current_user, session)
  end

  def set_total_books_count
    @total_books_count = @order.cart_items.sum(&:books_count)
  end
end
