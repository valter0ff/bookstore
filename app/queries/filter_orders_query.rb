# frozen_string_literal: true

class FilterOrdersQuery < ApplicationQuery
  def initialize(user_id, filter_option)
    @user_id = user_id
    @filter = filter_option
  end

  def call
    @orders = Order.states.key?(@filter) ? filtered_orders : all_orders
  end

  private

  attr_reader :current_user, :order

  def filtered_orders
    all_orders.where(state: @filter)
  end

  def all_orders
    Order.where(user_account_id: @user_id).complete
  end
end
