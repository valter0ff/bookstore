# frozen_string_literal: true

class ClientController < ApplicationController
  include Pagy::Backend
  before_action :set_all_categories

  private

  def set_all_categories
    @categories = Category.all
  end
end
