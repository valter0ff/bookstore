# frozen_string_literal: true

class ClientController < ApplicationController
  include Pagy::Backend

  before_action :set_all_categories
  before_action :set_order

  private

  def set_all_categories
    @categories = Category.all
  end

  def set_order
    @order = Orders::SetOrderService.call(current_user, session)
  end
end
