# frozen_string_literal: true

class ApplicationController < ActionController::Base
  include Pagy::Backend
  before_action :set_all_categories

  def set_all_categories
    @categories = Category.all
  end
end
