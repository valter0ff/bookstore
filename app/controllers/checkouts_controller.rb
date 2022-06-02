# frozen_string_literal: true

class CheckoutsController < ClientController
  before_action :authenticate_on_checkout, except: :login

  def login
    redirect_to checkout_address_path if user_signed_in?
  end

  def address
  end

  private

  def authenticate_on_checkout
    redirect_to checkout_login_path unless user_signed_in?
  end
end
