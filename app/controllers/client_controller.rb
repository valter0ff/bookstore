# frozen_string_literal: true

class ClientController < ApplicationController
  include Pagy::Backend
  include CurrentOrder

  before_action :set_all_categories
  before_action :set_order

  private

  def set_all_categories
    @categories = Category.all
  end
end
