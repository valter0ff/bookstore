# frozen_string_literal: true

class ClientController < ApplicationController
  include Pagy::Backend
  before_action :set_all_categories
  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found

  private

  def set_all_categories
    @categories = Category.all
  end

  def record_not_found
    flash[:error] = I18n.t('activerecord.errors.messages.not_found')
    render status: :not_found
  end
end
