# frozen_string_literal: true

class CategorySelector < ApplicationService
  def initialize(categories, controller_context)
    @categories = categories
    super(controller_context)
  end

  def call
    initialize_category_filter
    handle_category
    @category
  end

  private

  def initialize_category_filter
    session[:category_id] = params[:category_id] if params[:category_id]
  end

  def handle_category
    return if session[:category_id].blank?

    @category = @categories.find_by(id: session[:category_id])
  end
end
